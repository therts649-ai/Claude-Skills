---
name: taste-qt
description: Cómo aplicar las skills de taste-skill (Leonxlnx: design-taste-frontend, redesign-existing-projects, minimalist-ui, high-end-visual-design, full-output-enforcement) a una app de escritorio PySide6/PyQt (Qt Widgets). Esas skills están escritas para landing pages y webs con React/Tailwind; esta dice qué reglas se conservan, cómo se traducen a QSS y widgets, qué valores de sus «diales» usar en una app de trabajo y qué reglas no aplican. Úsala siempre que una de esas skills se active sobre pantallas Qt.
---

# taste-skill en Qt Widgets

taste-skill combate el «diseño genérico de IA» en páginas web: héroes, landing pages, bento grids,
GSAP, Tailwind. Una app de escritorio de trabajo (punto de venta, inventario, administración) no
tiene héroe ni scroll de marketing, pero sí comparte casi todos sus vicios: paletas por defecto,
tarjetas para todo, estados vacíos olvidados, botones que se cortan, copy de relleno.

## Diales para apps de trabajo

taste-skill pide fijar tres diales antes de diseñar. Para una app de escritorio de uso diario:

| Dial | Valor | Por qué |
|---|---|---|
| `DESIGN_VARIANCE` | 2–3 | La persona necesita encontrar todo siempre en el mismo lugar; asimetría y sorpresa estorban. |
| `MOTION_INTENSITY` | 1–2 | Pantallas que se usan cientos de veces al día; ver `diseno-qt` para lo poco que se anima. |
| `VISUAL_DENSITY` | 6–8 | Tablas, totales y listas con muchos datos; densidad de «cabina», con jerarquía clara. |

Equivale a su preset «trust-first / accessibility-critical» con más densidad. Escribe la
«Design Read» de una línea que pide la skill antes de cambiar algo.

## Qué reglas se conservan (traducidas)

| Regla de taste-skill | En Qt |
|---|---|
| Un solo color de acento, saturación < 80 %, una sola paleta por proyecto | Un acento en el tema (QSS) para la acción principal; los colores de estado (error, aviso, éxito) son semánticos, no decorativos. Nada de acentos nuevos en una sola pantalla. |
| Nada de negro puro `#000` | Texto casi negro y fondos oscuros que no sean `#000` en el modo oscuro. |
| Sombras teñidas del fondo, no negras | `QGraphicsDropShadowEffect.setColor()` con el tono del fondo y alfa bajo. |
| Tarjetas solo si la elevación significa jerarquía | En Qt, `QFrame` con borde y sombra solo para lo que flota o se selecciona; agrupa con espacio o una línea divisoria. Nunca tarjetas dentro de tarjetas. |
| Un solo radio de esquinas | Un valor de `border-radius` para todo el QSS (p. ej. 6 px en controles, el mismo en marcos). |
| Estados completos: cargando, vacío, error, presionado | `:pressed` con un cambio leve de fondo (Qt no tiene `scale` en QSS; ver `diseno-qt` para la escala); estado vacío que dice cómo llenarlo; errores en línea junto al campo, avisos flotantes solo para lo pasajero. |
| Contraste de botones y formularios (WCAG AA) | Revisa texto/fondo de cada botón, placeholders y mensajes de error en claro y oscuro. |
| El texto del botón cabe en una línea | Mínimo de ancho por `sizeHint`; si se corta, acorta la etiqueta (1–3 palabras) antes de reducir la letra. |
| Etiqueta encima del campo, error debajo, nunca el placeholder como etiqueta | `QFormLayout` o `QLabel` arriba del `QLineEdit`; `placeholderText` solo como ejemplo. |
| Sin datos falsos perfectos ni nombres genéricos | En capturas, demos y pruebas usa datos realistas del negocio (productos, precios con centavos, nombres locales). |
| Sin verbos de relleno («potencia», «sin fricciones», «eleva») | El copy dice la acción: «Cobrar», «Guardar producto», «Abrir caja». |
| Puntos de color decorativos prohibidos | Un indicador de color solo si comunica un estado real (impresora desconectada, stock bajo). |
| Iconos de una sola familia, nada de emoji como iconos | Un juego de SVG con el mismo trazo. Si el proyecto ya usa emoji, anótalo como hallazgo; no los cambies sin que el usuario lo pida. |
| Raya larga (—) prohibida en el texto visible | Aplica al **texto nuevo** que escribas en la interfaz: usa punto, coma, dos puntos o paréntesis. No reemplaces en masa textos existentes sin pedirlo. |
| Modo claro/oscuro: probar ambos antes de terminar | Captura cada pantalla cambiada en los dos modos. |

## Qué no aplica

- Todo lo de héroe, landing page, bento grid, zigzag, logos «Trusted by», navegación web,
  Core Web Vitals, `picsum.photos`, Tailwind, shadcn, GSAP y ScrollTrigger.
- Las listas de fuentes web (Geist, Satoshi…): en escritorio usa la fuente del sistema (Segoe UI
  en Windows) o una fuente incluida en los recursos de la app; no dependas de fuentes que la
  computadora de la tienda no tiene.
- `gpt-taste` (GSAP), `industrial-brutalist-ui` y `stitch-design-taste` (Google Stitch).
- `image-to-code`, `imagegen-frontend-web`, `imagegen-frontend-mobile` y `brandkit`: necesitan una
  herramienta de generación de imágenes.

## Skills del paquete según el caso

- `redesign-existing-projects`: la más útil en una app que ya existe. Su regla principal se
  conserva: auditar primero y mejorar **sin romper funcionalidad**. Sus correcciones de CSS se
  hacen en el QSS del tema.
- `full-output-enforcement`: aplica tal cual (código completo, sin `# ...resto igual`).
- `minimalist-ui` y `high-end-visual-design`: direcciones estéticas, no reglas. Úsalas solo si el
  usuario pide ese estilo.

## Verificar

Capturas con `QT_QPA_PLATFORM=offscreen` y `widget.grab()`, en claro y oscuro, a 1366×768 y a
tamaño grande; datos de peor caso (`break-ui`); y las pruebas que pida el CLAUDE.md del proyecto.
