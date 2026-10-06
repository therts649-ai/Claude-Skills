# Skills de diseño para Claude Code

Skills de diseño, animación e interfaz para usar en mis proyectos con Claude Code
(en la web, el escritorio o la terminal).

| Plugin | Qué trae |
| --- | --- |
| `emil-design` | Las 14 skills de [Emil Kowalski](https://github.com/emilkowalski/skills) **sin modificar** (licencia MIT, ver `plugins/emil-design/LICENSE`). Versión copiada: ver `plugins/emil-design/UPSTREAM_COMMIT`. |
| `impeccable` | [impeccable](https://github.com/pbakaus/impeccable) de Paul Bakaus **sin modificar** (Apache 2.0, ver `plugins/impeccable/LICENSE` y `NOTICE.md`): una skill con 24 comandos de diseño (`/impeccable critique`, `audit`, `polish`, `harden`, `clarify`…), 4 subagentes y, como plugin, los hooks de su detector para web. Versión copiada: `plugins/impeccable/UPSTREAM_COMMIT`. |
| `diseno-qt` | Adaptación propia a **PySide6/Qt Widgets**, con dos skills: `diseno-qt` traduce las reglas de Emil (escritas para web: CSS, React) — `QPropertyAnimation`, curvas Bezier en `QEasingCurve`, opacidad, avisos flotantes, reducir movimiento, peor caso — e `impeccable-qt` dice cómo usar impeccable en escritorio: qué comandos aplican, cuáles se traducen, su «craft floor» en QSS y cómo verificar con capturas. |

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

### impeccable en pocas palabras

- Lo usa Claude solo cuando trabajas en interfaz, o tú con `/impeccable <comando> [pantalla]`.
- La primera vez que corre baja un programa propio (`impeccable`) de los *releases* de GitHub de
  su autor y lo verifica con su suma SHA-256; queda en `~/.impeccable/`. Sin red, sigue
  funcionando leyendo `PRODUCT.md` y `DESIGN.md` directamente.
- Plataformas que entiende: web, iOS y Android. **Para escritorio Qt usa `impeccable-qt`**: el
  detector y el modo *live* (navegador) no aplican, y los hooks no se activan.
- En proyectos web, `/impeccable hooks on` activa el detector después de cada edición.
- La copia en `proyecto/impeccable/` es la variante para instalar dentro de `.claude/` de un
  proyecto (rutas `.claude/skills/impeccable/...`); la de `plugins/impeccable/` es la del plugin.

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
/plugin install impeccable@skills-therts649
/plugin install diseno-qt@skills-therts649
```

Como plugin, impeccable trae sus hooks activos (revisan archivos web después de cada edición).

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

## Actualizar impeccable

```bash
git clone --depth 1 https://github.com/pbakaus/impeccable /tmp/imp
rm -rf plugins/impeccable/{skills,agents,hooks,.claude-plugin}
cp -r /tmp/imp/plugin/{skills,agents,hooks,.claude-plugin} plugins/impeccable/
rm -rf proyecto/impeccable/skills/impeccable proyecto/impeccable/agents
cp -r /tmp/imp/.claude/skills/impeccable proyecto/impeccable/skills/
mkdir -p proyecto/impeccable/agents && cp /tmp/imp/.claude/agents/*.md proyecto/impeccable/agents/
for d in plugins/impeccable proyecto/impeccable; do cp /tmp/imp/LICENSE /tmp/imp/NOTICE.md $d/; done
git -C /tmp/imp rev-parse HEAD > plugins/impeccable/UPSTREAM_COMMIT
```

Revisa que `impeccable-qt` siga correspondiendo (comandos nuevos o renombrados).
