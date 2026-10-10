---
name: antislop-qt
description: Cómo aplicar las skills de anti-slop (miqdadbadjuber: antislop, antislop-ui, antislop-copywriting, antislop-human, antislop-layoutmobile, antislop-code) en una app de escritorio PySide6/PyQt (Qt Widgets) que se usa en español. Esas skills están escritas para webs y landing pages (CSS, href, móvil, 44 px); esta dice qué reglas se conservan, cómo se traducen a QSS y widgets, qué modo y qué diales usar, y qué reglas no aplican. Úsala siempre que una de ellas se active sobre pantallas Qt, textos de la app o comentarios del código.
---

# anti-slop en Qt Widgets

anti-slop es un **filtro**: no impone estilo, exige que cada decisión visual tenga un propósito
escrito y prohíbe lo deshonesto (datos inventados, controles muertos, contraste bajo). El núcleo es
`antislop/SKILL.md` (el «`antislop.md`» que citan las demás); cada skill hija profundiza un tema.
Este archivo y `CLAUDE.md` mandan sobre ellas.

## Instalación, modo y aviso

- **Ya está instalada.** El bloque `<!-- antislop:start -->` de `CLAUDE.md` es el «pointer block»
  del asistente de instalación: no vuelvas a correr el asistente, no ofrezcas `npx antislop-ai`,
  no descargues nada ni escribas en `~/.config/antislop/`.
- **Modo.** El orden de la skill se respeta: lo que el usuario diga en la conversación gana. Sin
  eso, el modo de este proyecto está fijado en `CLAUDE.md`: **during** al construir o modificar
  pantallas y textos, **after** cuando el usuario pide revisar o auditar. Por eso no se hace la
  pregunta «¿DURING o AFTER?»: el usuario pidió trabajar sin pedirle autorización. Anuncia una
  vez, en español: «antislop activo: during (preferencia del proyecto)».
- **Modo after.** El reporte numerado va en `docs/anti-slop/auditoria-NNN-AAAA-MM-DD.md` y no se
  cambia nada hasta que el usuario elija números, igual que en la skill.

## Dirección de diseño (R-37) y diales

No hay `DESIGN.md`, pero sí hay dirección escrita y aprobada por el dueño: el tema (`src/pos_modelorama/ui/theme.py`,
`ui/estilos/`), `docs/design/` y las skills `diseno-qt`, `taste-qt` e `impeccable-qt`. Eso cuenta
como dirección: no etiquetes el trabajo como «draft without direction».

| Dial | Valor | Por qué |
|---|---|---|
| ENERGY | 1 | Herramienta de trabajo; la venta y el dinero son el foco, no la app. |
| RHYTHM | 1 | Cada cosa siempre en el mismo lugar; el cajero trabaja de memoria. |
| MOTION | 1 | Solo retroalimentación (presionar, escaneo, avisos); ver `diseno-qt`. |

«Design Read» de una línea antes de tocar una pantalla, por ejemplo: «Leo esto como: pantalla de
cobro de punto de venta para cajeros, lenguaje sobrio de cabina, ENERGY 1 / RHYTHM 1 / MOTION 1».
El «acento deliberado» es el color de acento del tema en la acción principal; el «motivo de
identidad» ya existe (logo, tarjetas de producto, cifras tabulares).

## Reglas del Hard Gate traducidas

| Regla | En esta app |
|---|---|
| R-02 raya (—) | No uses raya en textos **nuevos** de la interfaz, avisos ni ayuda: punto, coma, dos puntos o paréntesis. La «—» como marcador de «sin dato» en celdas y etiquetas es un valor, no prosa: se queda. No reescribas textos existentes en masa sin que el usuario lo pida. Commits y comentarios siguen el estilo del repo. |
| R-03 móvil | No aplica tal cual. Se traduce a: ventana a 1366×768 y a 1920×1080, letra al 100 % y al 130 %, sin texto cortado ni desbordes, botones que no bajen de la altura mínima que ya fija el QSS (`ui/estilos/controles.py`), ventanas emergentes dentro de la pantalla. |
| R-17, R-18, R-36, R-38 datos | Nunca números, nombres ni reseñas inventados en la interfaz. Cifras solo de la base. En capturas y pruebas, datos realistas del negocio, presentados como de prueba. |
| R-23 recursos | Logos e íconos: el usuario los elige (pantalla «Diseño & Logos»). Los íconos SVG del tema ya están aprobados. |
| R-24, R-26 controles muertos | Todo botón, acción de menú y atajo (F1–F12) hace algo real; si no, se quita. Un `QDialog` se cierra con Esc. |
| R-25 contraste | WCAG AA (4,5:1 texto normal, 3:1 grande) en **cada** modo del tema (Claro, Día, Noche y Alto Contraste, `PRESETS_MODO_VISUAL` en `ui/theme.py`), incluidos placeholders, celdas de color y texto deshabilitado. Usa `antislop-human/contrast-check.py "#texto" "#fondo"` con los colores del QSS. |
| R-27 estados | Vacío que dice cómo llenarlo (`vigilar_tabla_vacia`), cargando (cursor de espera o carga diferida) y error en línea o aviso flotante que dice qué hacer. |
| R-32 teclado | Orden de Tab lógico, Enter avanza o confirma, Esc cierra, foco visible (`ui/foco_teclado.py`). Nunca quitar el anillo de foco sin otro igual de visible. Un widget que se muestra antes de estar en su pantalla abre una ventana suelta y le roba el teclado a la app: dale dueño o solo ocúltalo (prueba en `tests/test_ui_main_window.py`). |
| R-33 parches por script | No cambies QSS ni código con scripts de reemplazo de texto como entrega; edita la fuente. |
| R-34 temas | Cada cambio visual se revisa en todos los modos del tema. |
| R-35 verificar | Equivale a: pruebas en `offscreen` (las de Ventas siempre, por `CLAUDE.md`), capturas con `widget.grab()` en cada modo y un recorrido por los controles tocados. El reporte de entrega lista cada control y lo que hizo, en español. |

## Purpose-Gate y Quality Locks en Qt

- Sombras (`QGraphicsDropShadowEffect`), brillos, degradados y tarjetas: solo con una razón de
  jerarquía escrita (en el código o en el resumen). Nunca tarjetas dentro de tarjetas.
- Íconos: relacionados con su acción; nada de chispas, estrellas o «magia».
- Un radio de esquinas para todo el QSS; nada de todo en forma de píldora.
- Paleta: la del tema (fondo, texto, acento y colores de estado). No agregues colores sueltos en una
  sola pantalla.
- Copy (R-15, R-16, `antislop-copywriting`): verbos de la acción real («Cobrar», «Guardar
  producto», «Cerrar turno»), nada de «Comenzar», «Descubrir», «potente», «sin fricciones». Sus
  listas de frases delatoras están en inglés; aplica la idea en español (relleno, triadas forzadas,
  frases para «sonar profundas»).
- Partes de landing (héroe, testimonios, FAQ, precios en 3 columnas, «Trusted by»): no aplican.

## Comentarios del código (`antislop-code`)

Úsala al escribir o editar comentarios, sin tocar el código. En este repo valen mucho los
comentarios que dicen **por qué** y **quién lo pidió** («Pedido del usuario: …», «issue #3»): se
conservan. Se quitan los que repiten lo que el código ya dice o son decorativos. No hagas
limpiezas masivas de comentarios si el usuario no lo pidió; `CLAUDE.md` pide igualar la densidad
de comentarios del código vecino.

## Delivery Gate

Antes de entregar trabajo de interfaz o de textos, recorre los cuatro bloques del núcleo con estas
traducciones y escribe en el resumen las líneas que fallarían (o «pasa» con su evidencia: prueba,
captura o control recorrido). Este gate no reemplaza el informe de Ventas que exige `CLAUDE.md`:
van los dos.
