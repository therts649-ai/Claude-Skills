---
name: diseno-qt
description: Traduce a PySide6/PyQt (Qt Widgets de escritorio) las reglas de diseño y animación de las skills de Emil Kowalski (emil-design-eng, animate, review-animations, improve-animations, find-animation-opportunities, apple-design, break-ui), que están escritas para web (CSS, React). Úsala siempre que trabajes en animaciones, transiciones, retroalimentación al presionar, avisos flotantes, ventanas emergentes, pulido visual o pruebas de «peor caso» en una app Qt; también cuando una de esas skills proponga CSS, Framer Motion o media queries que en Qt no existen.
---

# Diseño y animación en Qt (PySide6)

Las skills de Emil Kowalski fijan el criterio: **cuándo** animar, **para qué**, con qué curva y
duración, y qué nunca hacer. Ese criterio vale igual en una app de escritorio. Lo que cambia es la
**herramienta**: Qt Widgets no tiene CSS transitions, `transform`, `@starting-style` ni media
queries. Esta skill es el diccionario entre las dos.

Úsala junto con la skill de Emil que toque: aplica sus reglas y su formato de salida (tabla
Antes/Después/Por qué en revisiones), y escribe la implementación con lo de aquí.

## 1. Primero la frecuencia (igual que en web, y más en un punto de venta)

| Frecuencia | Decisión | Ejemplos en una app de escritorio de negocio |
| --- | --- | --- |
| 100+ veces al día | **Sin animación. Nunca.** | Escanear/agregar producto, teclas F, cambiar de pestaña, cobrar, buscar, navegar entre pantallas |
| Decenas al día | Casi imperceptible o nada | Hover de botones, selección en tablas, abrir un menú |
| Ocasional | Animación estándar | Avisos flotantes (toasts), ventanas emergentes, paneles que aparecen |
| Rara / primera vez | Aquí vive el «deleite» | Primeros pasos, corte de caja cuadrado, recorrido guiado |

**Todo lo que se dispara con el teclado no se anima.** En un punto de venta eso es casi todo el
flujo de cobro. Si la petición cae aquí, dilo y no escribas la animación.

## 2. Equivalencias web → Qt

| En las skills (web) | En Qt Widgets |
| --- | --- |
| `transition` / WAAPI / Motion | `QPropertyAnimation` (una propiedad de un objeto) o `QVariantAnimation` (valor libre + `valueChanged`) |
| Varias propiedades a la vez | `QParallelAnimationGroup`; en secuencia, `QSequentialAnimationGroup`; escalonado (stagger) con `QSequentialAnimationGroup.addPause(ms)` o retrasos de 30–80 ms |
| `opacity` | Ventanas de primer nivel (diálogos, avisos sin padre): `windowOpacity`. Widgets hijos: `QGraphicsOpacityEffect` (ver §5, tiene costo y choca con sombras) |
| `transform: translate()` | Animar `pos` **solo** en widgets fuera de layout (superpuestos, flotantes, `move()` manual). Dentro de un layout, el layout los regresa a su lugar |
| `transform: scale(0.97)` al presionar | Qt Widgets no escala widgets. Usa el estado `:pressed` en la hoja de estilos (color/borde un tono más oscuro, instantáneo). No animes `geometry` para simular escala en botones: cuesta layout y se ve borroso |
| `height` en acordeón | `maximumHeight` de 0 → `sizeHint().height()`; corto (≤ 200 ms) porque recalcula layout en cada cuadro |
| `@starting-style` (entrada) | Fija el valor inicial **antes** de `show()` (opacidad 0, posición desplazada) y arranca la animación justo después |
| `clip-path` | `setMask()` o pintar en `paintEvent` con `QPainter.setClipRect`; rara vez vale la pena en Widgets |
| `filter: blur()` | `QGraphicsBlurEffect` — caro; evítalo en algo que se repita |
| `:hover` con `@media (hover: hover)` | `:hover` en la hoja de estilos. Si la app corre en **pantalla táctil** (común en cajas), no pongas nada importante solo en hover: en táctil se queda «pegado» o nunca aparece |
| `prefers-reduced-motion` | Qt no lo expone. Ofrece una opción «Reducir animaciones» en la configuración de la app y, en Windows, respeta la del sistema (§6) |
| Springs (Motion) | No hay springs en Qt Widgets. Para gestos de arrastre usa `QVariantAnimation` con la curva de cajón y velocidad calculada a mano; en Widgets casi nunca hace falta |

## 3. Curvas: las mismas de Emil, en `QEasingCurve`

Las curvas incluidas en Qt (`OutCubic`, `InOutSine`…) son tan débiles como las de CSS. Usa las de
Emil como `BezierSpline` (verificadas en PySide6 6.11):

```python
from PySide6.QtCore import QEasingCurve, QPointF

def curva_bezier(x1: float, y1: float, x2: float, y2: float) -> QEasingCurve:
    curva = QEasingCurve(QEasingCurve.Type.BezierSpline)
    curva.addCubicBezierSegment(QPointF(x1, y1), QPointF(x2, y2), QPointF(1.0, 1.0))
    return curva

EASE_OUT = curva_bezier(0.23, 1, 0.32, 1)        # entrar/salir — la de casi todo
EASE_IN_OUT = curva_bezier(0.77, 0, 0.175, 1)    # algo que ya está en pantalla y se mueve
EASE_CAJON = curva_bezier(0.32, 0.72, 0, 1)      # paneles laterales / inferiores
```

- Entrar o salir → `EASE_OUT`. Moverse en pantalla → `EASE_IN_OUT`. Cambio de color → `OutCubic`
  basta. Progreso constante → `Linear`.
- **Nunca `In*` (`InQuad`, `InCubic`…) en interfaz**: empieza lento justo cuando el usuario mira.
- Guarda las curvas en **un solo módulo** del proyecto (p. ej. `ui/movimiento.py`) junto con las
  duraciones; no las repitas en cada pantalla.

## 4. Duraciones

| Elemento | Duración |
| --- | --- |
| Retroalimentación al presionar | instantánea (`:pressed`) |
| Tooltip, aviso pequeño | 125–200 ms |
| Menú, lista desplegable | Usa la del sistema/estilo; no la reescribas |
| Diálogo, panel, aviso flotante | 200–300 ms (salida ~20 % más rápida que la entrada) |
| Explicativo / primera vez | Puede ser más largo |

Interfaz: **menos de 300 ms**. El temporizador de Qt avanza en cuadros de ~16 ms, así que 150 ms
son ~9 cuadros: suficientes.

## 5. Rendimiento y trampas propias de Qt

- **Un widget solo admite un `QGraphicsEffect`.** Si ya tiene sombra (`QGraphicsDropShadowEffect`),
  ponerle `QGraphicsOpacityEffect` le **quita la sombra**. Anima la opacidad de un contenedor padre,
  o usa `windowOpacity` si es una ventana.
- `QGraphicsEffect` dibuja fuera de pantalla: caro en widgets grandes o muchos a la vez. Quita el
  efecto (`setGraphicsEffect(None)`) al terminar la animación.
- Animar `geometry`/`maximumHeight` recalcula el layout del padre en cada cuadro. Mantenlo corto y
  en widgets pequeños; nunca en filas de una tabla con muchos renglones.
- Guarda una referencia a la animación (`self._animacion = ...`) o créala con padre; si no, el
  recolector de basura la detiene a medio camino. Usa
  `start(QAbstractAnimation.DeletionPolicy.DeleteWhenStopped)` para las de una sola vez.
- **Interrumpible**: si el usuario dispara la acción de nuevo, detén la animación en curso y arranca
  la nueva **desde el valor actual** (`animacion.currentValue()` o la propiedad leída en ese
  momento), no desde el inicio. Es el equivalente a «transiciones, no keyframes».
- `windowOpacity` necesita compositor; en algunos escritorios Linux remotos no hace nada. Que la
  interfaz funcione igual sin animación.

## 6. Reducir movimiento

Qt no trae `prefers-reduced-motion`. Haz las dos cosas:

1. Una opción en la configuración de la app («Reducir animaciones») que deje solo cambios de
   opacidad cortos y quite desplazamientos.
2. En Windows, respeta la opción del sistema «Mostrar animaciones en Windows»:

```python
import sys

def sistema_pide_menos_movimiento() -> bool:
    if sys.platform != "win32":
        return False
    import ctypes
    SPI_GETCLIENTAREAANIMATION = 0x1042
    activo = ctypes.c_bool(True)
    ctypes.windll.user32.SystemParametersInfoW(SPI_GETCLIENTAREAANIMATION, 0, ctypes.byref(activo), 0)
    return not activo.value
```

Reducir no es quitar todo: un desvanecimiento breve que explica un cambio de estado se queda.

## 7. Receta: aviso flotante (toast) que entra y sale por el mismo lado

```python
from PySide6.QtCore import QAbstractAnimation, QParallelAnimationGroup, QPoint, QPropertyAnimation

def mostrar_con_entrada(aviso, destino: QPoint, reducir: bool) -> QParallelAnimationGroup:
    """`aviso` es una ventana sin marco (Qt.WindowType.ToolTip o FramelessWindowHint)."""
    grupo = QParallelAnimationGroup(aviso)
    opacidad = QPropertyAnimation(aviso, b"windowOpacity", grupo)
    opacidad.setDuration(250)
    opacidad.setStartValue(0.0)
    opacidad.setEndValue(1.0)
    opacidad.setEasingCurve(EASE_OUT)
    grupo.addAnimation(opacidad)
    if not reducir:
        posicion = QPropertyAnimation(aviso, b"pos", grupo)
        posicion.setDuration(250)
        posicion.setStartValue(destino + QPoint(0, 12))   # 12 px abajo, nunca desde «la nada»
        posicion.setEndValue(destino)
        posicion.setEasingCurve(EASE_OUT)
        grupo.addAnimation(posicion)
    aviso.setWindowOpacity(0.0)
    aviso.move(destino if reducir else destino + QPoint(0, 12))
    aviso.show()
    grupo.start(QAbstractAnimation.DeletionPolicy.DeleteWhenStopped)
    return grupo
```

La salida usa lo mismo invertido, en ~200 ms, hacia el mismo lado por el que entró.

## 8. «Peor caso» (break-ui) en Qt

Los mismos datos de la skill `break-ui` (nombres largos, correos sin espacios, «1 producto»,
listas vacías, 1 000 renglones, cantidades enormes), con las herramientas de Qt:

| Lo que se ve | Causa | Arreglo en Qt |
| --- | --- | --- |
| Texto cortado sin «…» | `QLabel` de ancho fijo | `QFontMetrics.elidedText(texto, Qt.TextElideMode.ElideRight, ancho)` + `setToolTip(texto completo)` |
| Etiqueta que empuja botones fuera de la fila | `QLabel` sin política de tamaño | `setSizePolicy(Ignored/Preferred)` o `setMinimumWidth(0)` en el texto, ancho fijo solo en el botón |
| Palabra larga (correo, código) que no envuelve | `setWordWrap(True)` solo parte en espacios | Elidir, o insertar `​` en puntos de corte |
| Encabezado de tabla aplastado | Ancho calculado con la letra base | Medir con la letra real (`fontMetrics`) y volver a medir al cambiar el tamaño de letra |
| Diálogo más alto que la pantalla | Contenido sin desplazamiento | Envolver en `QScrollArea` y limitar a `screen().availableGeometry()` |
| «1 productos» | Plural fijo | Texto distinto para 1 y para el resto |
| Números que «brincan» al cambiar | Fuente proporcional | Fuente monoespaciada o tabular para importes y contadores |

Pruébalo con la letra al 100 %, 115 % y **130 %**, a 1366×768 y en los modos de color que tenga la
app (claro, oscuro, alto contraste). Con `QT_QPA_PLATFORM=offscreen` y `widget.grab().save(...)` se
sacan capturas para revisarlas sin pantalla.

## 9. Pruebas

- En las pruebas, que las animaciones duren 0 ms (una constante del módulo de movimiento que la
  prueba pueda sustituir) para no esperar ni depender de tiempos.
- Comprueba el **estado final** (visible, opacidad 1, posición destino), no los cuadros intermedios.
- Si la animación se interrumpe, prueba que la segunda llamada no deje el widget a medio camino.

## Formato de salida

El de la skill de Emil que estés aplicando. En revisiones, la tabla **Antes | Después | Por qué**,
con el código Qt en la columna «Después».
