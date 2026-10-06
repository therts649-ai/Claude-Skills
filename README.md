# Skills de diseño para Claude Code

Skills de diseño, animación e interfaz para usar en mis proyectos con Claude Code
(en la web, el escritorio o la terminal).

| Plugin | Qué trae |
| --- | --- |
| `emil-design` | Las 16 skills de [Emil Kowalski](https://github.com/emilkowalski/skills) **sin modificar** (licencia MIT, ver `plugins/emil-design/LICENSE`). Versión copiada: ver `plugins/emil-design/UPSTREAM_COMMIT`. |
| `diseno-qt` | Adaptación propia: traduce esas reglas (escritas para web: CSS, React) a **PySide6/Qt Widgets** — `QPropertyAnimation`, curvas Bezier en `QEasingCurve`, opacidad, avisos flotantes, reducir movimiento y pruebas de «peor caso». |

### Skills de `emil-design`

| Skill | Para qué |
| --- | --- |
| `emil-design-eng` | Filosofía de pulido de interfaces y animación (la principal) |
| `animate` | Construir una animación desde cero con la curva y duración correctas |
| `review-animations` | Revisar animaciones con criterio estricto (se invoca a mano) |
| `improve-animations` | Auditar todas las animaciones y escribir planes de mejora |
| `find-animation-opportunities` | Dónde sí conviene animar y dónde no |
| `animation-vocabulary` | El nombre exacto de un efecto («¿cómo se llama cuando…?») |
| `apple-design` | Principios de Apple (WWDC) de interfaz fluida, traducidos a web |
| `break-ui` | Romper la interfaz con datos de peor caso |
| `mobile-native` | Que una web se sienta nativa en el teléfono |
| `pick-ui-library` | Elegir librería de frontend (se invoca a mano) |
| `prototype` | Varias versiones de un componente para comparar (se invoca a mano) |
| `ask-sonner` | Guía de la librería de toasts Sonner |
| `animate-expo` | Animación en React Native / Expo |
| `write-swift` | Swift moderno |

## Usarlas en otro proyecto

### Opción A — copiarlas al proyecto (la más simple, funciona en cualquier sesión)

Pídele a Claude en el proyecto nuevo:

> Clona `therts649-ai/claude-skills` y ejecuta `instalar.sh` sobre este proyecto con el perfil `qt`.

O a mano:

```bash
git clone https://github.com/therts649-ai/claude-skills /tmp/claude-skills
bash /tmp/claude-skills/instalar.sh . qt     # perfiles: qt (escritorio), web, todo
```

Las skills quedan en `.claude/skills/` del proyecto; haz commit para que se carguen en cada sesión.

### Opción B — como plugin (se actualizan desde aquí)

En una sesión de Claude Code:

```
/plugin marketplace add therts649-ai/claude-skills
/plugin install emil-design@skills-therts649
/plugin install diseno-qt@skills-therts649
```

Si el repositorio es privado, la máquina necesita credenciales de git para leerlo
(`gh auth login` y `gh auth setup-git`). En sesiones en la nube, la opción A es la más segura.

## Actualizar las skills de Emil

```bash
git clone --depth 1 https://github.com/emilkowalski/skills /tmp/emil
rm -rf plugins/emil-design/skills && cp -r /tmp/emil/skills plugins/emil-design/skills
cp /tmp/emil/LICENSE plugins/emil-design/LICENSE
git -C /tmp/emil rev-parse HEAD > plugins/emil-design/UPSTREAM_COMMIT
```

Revisa el contenido nuevo antes de hacer commit, y que `diseno-qt` siga correspondiendo.
