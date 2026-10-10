# Skills para Claude Code

Skills de diseño, animación, interfaz e ingeniería para usar en mis proyectos con Claude Code
(en la web, el escritorio o la terminal).

| Plugin | Qué trae |
| --- | --- |
| `emil-design` | Las 14 skills de [Emil Kowalski](https://github.com/emilkowalski/skills) **sin modificar** (licencia MIT, ver `plugins/emil-design/LICENSE`). Versión copiada: ver `plugins/emil-design/UPSTREAM_COMMIT`. |
| `impeccable` | [impeccable](https://github.com/pbakaus/impeccable) de Paul Bakaus **sin modificar** (Apache 2.0, ver `plugins/impeccable/LICENSE` y `NOTICE.md`): una skill con 24 comandos de diseño (`/impeccable critique`, `audit`, `polish`, `harden`, `clarify`…), 4 subagentes y, como plugin, los hooks de su detector para web. Versión copiada: `plugins/impeccable/UPSTREAM_COMMIT`. |
| `taste-skill` | [taste-skill](https://github.com/Leonxlnx/taste-skill) de Leonxlnx **sin modificar** (MIT, ver `plugins/taste-skill/LICENSE`): 13 skills contra el diseño genérico de IA. Versión copiada: `plugins/taste-skill/UPSTREAM_COMMIT`. |
| `diseno-qt` | Adaptación propia a **PySide6/Qt Widgets**, con cuatro skills: `diseno-qt` traduce las reglas de Emil (escritas para web: CSS, React) — `QPropertyAnimation`, curvas Bezier en `QEasingCurve`, opacidad, avisos flotantes, reducir movimiento, peor caso — e `impeccable-qt` dice cómo usar impeccable en escritorio: qué comandos aplican, cuáles se traducen, su «craft floor» en QSS y cómo verificar con capturas; y `taste-qt` dice qué reglas de taste-skill se conservan en escritorio, cómo se traducen a QSS y qué valores de sus «diales» usar en una app de trabajo; `antislop-qt` traduce las reglas de anti-slop (contraste en cada modo del tema, teclado, estados, verificar con pruebas y capturas) y dice cuáles no aplican en escritorio. |
| `mattpocock-skills` | Las 27 skills estables de [Matt Pocock](https://github.com/mattpocock/skills) **sin modificar** (MIT, ver `plugins/mattpocock-skills/LICENSE`): proceso de ingeniería (entrevista, especificación, tickets, TDD, revisión, diagnóstico de errores, arquitectura). No incluye las de `in-progress` (beta). Versión copiada: `plugins/mattpocock-skills/UPSTREAM_COMMIT`. |
| `ingenieria-python` | Adaptación propia: cómo usar las de Matt en proyectos **Python** (pytest, `monkeypatch`, PySide6), en Claude Code en la nube (sin CLI `gh`) y con un `CLAUDE.md` que manda (subagentes, pruebas obligatorias, idioma). |
| `anti-slop` | Las 6 skills de [anti-slop](https://github.com/miqdadbadjuber/anti-slop) de Miqdad Badjuber **sin modificar** (MIT, ver `plugins/anti-slop/LICENSE`): un filtro contra el «AI slop» que exige propósito escrito para cada técnica visual y prohíbe lo deshonesto (datos inventados, controles muertos, contraste bajo). `antislop` es el núcleo; `antislop-ui`, `antislop-copywriting`, `antislop-human` (con `contrast-check.py`), `antislop-layoutmobile` y `antislop-code` profundizan un tema. Para Qt se usan con `antislop-qt` (en `diseno-qt`). Versión copiada: `plugins/anti-slop/UPSTREAM_COMMIT`. |

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

### Skills de `taste-skill`

| Skill (carpeta) | Para qué | Perfiles |
| --- | --- | --- |
| `design-taste-frontend` (`taste-skill`) | La principal: diales de diseño, reglas contra «AI tells», revisión final | qt, web |
| `redesign-existing-projects` (`redesign-skill`) | Auditar y mejorar un proyecto existente sin romperlo | qt, web |
| `full-output-enforcement` (`output-skill`) | Código completo, sin «...resto igual» | qt, web |
| `minimalist-ui`, `high-end-visual-design` (`soft-skill`), `industrial-brutalist-ui` | Direcciones estéticas | web |
| `gpt-taste` | Variante con GSAP | web |
| `stitch-design-taste` | DESIGN.md para Google Stitch | web |
| `image-to-code`, `imagegen-frontend-web`, `imagegen-frontend-mobile`, `brandkit` | Necesitan generar imágenes | todo |
| `design-taste-frontend-v1` | Versión anterior, por compatibilidad | todo |

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

### Skills de `mattpocock-skills`

| Skill | Para qué |
| --- | --- |
| `ask-matt` | Cuál skill usar y en qué orden |
| `grill-me`, `grilling`, `grill-with-docs` | Entrevista implacable para afinar un plan (con glosario/ADRs en la última) |
| `to-spec`, `to-tickets`, `to-questionnaire` | Pasar la conversación a especificación, tickets o cuestionario |
| `tdd` | Rojo → verde, una rebanada vertical a la vez, en «seams» acordados |
| `implement`, `implement-spec` | Construir un ticket o una especificación completa (con `tdd` y revisión al final) |
| `code-review` (se instala como `code-review-matt`) | Revisión en dos ejes: estándares del repo y especificación |
| `diagnosing-bugs` | Diagnóstico disciplinado: reproducir, aislar, probar la causa |
| `codebase-design`, `improve-codebase-architecture` | Módulos profundos: vocabulario y un informe de oportunidades |
| `domain-modeling` | Glosario del negocio y ADRs |
| `triage`, `wayfinder`, `research`, `prototype`, `pr`, `retro`, `wizard` | Triage de issues, orientarse, investigar, prototipos desechables, PRs, retrospectiva, asistentes bash |
| `handoff`, `teach`, `wait-what`, `writing-for-agents` | Traspaso de sesión, enseñar un tema, aclarar confusiones, escribir para agentes |
| `setup-matt-pocock-skills` | Configura issue tracker, etiquetas y glosario del repo (interactiva, se invoca a mano) |

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

Las de ingeniería (Matt Pocock + `ingenieria-python`) van con su propio instalador:

```bash
bash /tmp/claude-skills/instalar-ingenieria.sh .
```

Renombra `code-review` → `code-review-matt` (y `prototype` → `prototype-matt` si ya hay otra
`prototype`) y actualiza las referencias entre skills; agrega una sección al `CLAUDE.md` del
proyecto que diga que se usan con `ingenieria-python`.

Las de anti-slop (+ `antislop-qt`) también:

```bash
bash /tmp/claude-skills/instalar-antislop.sh .
```

Luego agrega al final del `CLAUDE.md` del proyecto el bloque `<!-- antislop:start -->` …
`<!-- antislop:end -->` con las rutas a `.claude/skills/antislop*/SKILL.md` y el modo del proyecto
(`during`/`after`). Sin ese bloque, su núcleo corre su asistente de instalación y pregunta el modo
en cada sesión. Ejemplo: el `CLAUDE.md` de `therts649-ai/Compilar`.

### Opción B — como plugin (se actualizan desde aquí)

En una sesión de Claude Code:

```
/plugin marketplace add therts649-ai/claude-skills
/plugin install emil-design@skills-therts649
/plugin install impeccable@skills-therts649
/plugin install taste-skill@skills-therts649
/plugin install diseno-qt@skills-therts649
/plugin install mattpocock-skills@skills-therts649
/plugin install ingenieria-python@skills-therts649
/plugin install anti-slop@skills-therts649
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

## Actualizar taste-skill

```bash
git clone --depth 1 https://github.com/Leonxlnx/taste-skill /tmp/taste
rm -rf plugins/taste-skill/skills && cp -r /tmp/taste/skills plugins/taste-skill/skills
rm -f plugins/taste-skill/skills/llms.txt
cp /tmp/taste/LICENSE plugins/taste-skill/LICENSE
git -C /tmp/taste rev-parse HEAD > plugins/taste-skill/UPSTREAM_COMMIT
```

Revisa que `taste-qt` siga correspondiendo.

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

## Actualizar las skills de Matt Pocock

```bash
git clone --depth 1 https://github.com/mattpocock/skills /tmp/matt
rm -rf plugins/mattpocock-skills && mkdir -p plugins/mattpocock-skills/.claude-plugin
python3 -c "import json,shutil;p=json.load(open('/tmp/matt/.claude-plugin/plugin.json'));[shutil.copytree('/tmp/matt/'+r,'plugins/mattpocock-skills/'+r) for r in p['skills']]"
cp /tmp/matt/.claude-plugin/plugin.json plugins/mattpocock-skills/.claude-plugin/
cp /tmp/matt/LICENSE plugins/mattpocock-skills/LICENSE
git -C /tmp/matt rev-parse HEAD > plugins/mattpocock-skills/UPSTREAM_COMMIT
```

Revisa que `ingenieria-python` siga correspondiendo (skills nuevas, renombradas o que ahora
usen otras herramientas).

## Actualizar anti-slop

```bash
git clone --depth 1 https://github.com/miqdadbadjuber/anti-slop /tmp/anti-slop
rm -rf plugins/anti-slop/skills && cp -r /tmp/anti-slop/skills plugins/anti-slop/skills
cp /tmp/anti-slop/LICENSE plugins/anti-slop/LICENSE
git -C /tmp/anti-slop rev-parse HEAD > plugins/anti-slop/UPSTREAM_COMMIT
```

Revisa el contenido nuevo antes de hacer commit (son instrucciones que Claude obedece), y que
`antislop-qt` siga correspondiendo a sus reglas (R-01 a R-38).
