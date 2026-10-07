---
name: ingenieria-python
description: Cómo usar las skills de ingeniería de Matt Pocock (tdd, code-review-matt, diagnosing-bugs, grill-me, to-spec, to-tickets, implement, triage, codebase-design, improve-codebase-architecture, domain-modeling, prototype, pr, handoff…) en un proyecto Python (pytest, ruff; PySide6 si hay interfaz), en Claude Code en la nube y con un CLAUDE.md que manda. Esas skills traen ejemplos en TypeScript, suponen el CLI `gh` y lanzan subagentes en paralelo; esta dice cómo traducir cada cosa. Úsala siempre que una de ellas se active en un proyecto Python.
---

# Skills de Matt Pocock en proyectos Python

Las skills de [mattpocock/skills](https://github.com/mattpocock/skills) son casi todas de
proceso (entrevistar, especificar, partir en tickets, TDD, revisar, diagnosticar) y sirven en
cualquier lenguaje. Lo que hay que traducir son sus ejemplos (TypeScript, Vitest/Jest), sus
herramientas (`gh`, `pnpm`) y su forma de trabajar con subagentes.

## Orden de prioridad

1. Lo que pida el usuario.
2. El `CLAUDE.md` del proyecto (pruebas obligatorias, pantallas críticas, formato de commits,
   idioma, «subagentes solo si el usuario los pide»).
3. Las skills de Matt.

Si una skill dice «lanza dos subagentes en paralelo» y el `CLAUDE.md` dice que no sin permiso,
haz el trabajo en el mismo hilo, uno después del otro, y dilo en una línea en el informe
(«revisión en un solo contexto: el proyecto no permite subagentes sin pedirlos»).

## Nombres

- `code-review-matt` es la `code-review` de Matt renombrada al instalarla, para no tapar el
  `/code-review` que ya trae Claude Code. Donde sus skills dicen «call the Skill tool with
  "code-review"», ya dice `code-review-matt`.
- Si el proyecto también tiene la `prototype` de Emil Kowalski (perfil web), la de Matt se
  instala como `prototype-matt`.

## Traducciones

| En las skills | En un proyecto Python |
|---|---|
| `expect(x).toBe(y)`, `describe/it`, Vitest/Jest | `assert x == y`, funciones `test_…` de pytest, `pytest.raises`, `pytest.mark.parametrize` |
| `jest.mock(...)` / mocks de colaboradores internos | `monkeypatch` o un falso pasado por parámetro, **solo en la frontera** (red, impresora, reloj, base externa). Para SQLite usa una base real en `tmp_path`, no un mock |
| «Run typechecking regularly» | `ruff check` (y `mypy`/`pyright` si el proyecto los usa); `python -m compileall -q src` como mínimo |
| «single test files regularly, full suite at the end» | `pytest -q tests/test_x.py -k nombre`, y la suite completa antes de push. Si la suite tarda, córrela en segundo plano |
| Pruebas de interfaz | `QT_QPA_PLATFORM=offscreen` con PySide6; prueba la pantalla por sus métodos y widgets públicos, no por atributos privados |
| `interface`, módulo profundo (codebase-design) | Un módulo o paquete con pocas funciones públicas (sin `_`) que esconden mucho; el «seam» es esa API pública o la frontera con la base de datos/impresora |
| `pnpm <script>` (prototype) | `python ruta/al/prototipo.py`; un prototipo de interfaz Qt es un script suelto con un `QWidget`, fuera de `src/` |
| `wizard` (script bash) | Igual en Linux/macOS; si el humano usa Windows, ofrece además los pasos en texto o un `.ps1` |
| `GLOSSARY.md`, `docs/adr/` | Igual. En proyectos en español, los términos del glosario van en español, como los usa el negocio |

## Issue tracker y GitHub

- `/setup-matt-pocock-skills` es interactiva: córrela solo cuando el usuario la pida. Escribe
  `docs/agents/*.md` y una sección `## Agent skills` en el `CLAUDE.md` (es un cambio al
  `CLAUDE.md`: confírmalo con el usuario).
- Sin esa configuración, `to-spec`, `to-tickets`, `triage` y `code-review-matt` preguntan
  dónde están los issues. Para un proyecto de una sola persona, lo más simple es
  **markdown local** (`.scratch/<tema>/`).
- En Claude Code en la nube **no hay CLI `gh` real**: donde las skills dicen `gh issue create`,
  `gh pr create`, `gh label create`, usa las herramientas del servidor MCP de GitHub
  (`issue_write`, `create_pull_request`, `list_issues`…) o `gh api <endpoint REST>`. No crees
  PRs ni etiquetas si el usuario no lo pidió.
- `handoff` y `claude-handoff` suponen la terminal (`claude --bg`): en la nube, el resumen de
  traspaso se escribe como archivo y el usuario abre la sesión nueva.

## Idioma

Si el usuario escribe en español, las preguntas de `grill-me`/`grilling`, los tickets, las
especificaciones y los informes van en español. Mantén en inglés solo los nombres de las skills
y los términos técnicos sin traducción común.

## Qué skill usar

| Para | Skill |
|---|---|
| Afinar una idea antes de programar (entrevista) | `grill-me` (o `grill-with-docs` si hay glosario/ADRs) |
| Escribir la especificación / partirla en tickets | `to-spec`, `to-tickets` |
| Construir con pruebas primero | `tdd` (acordar los «seams» con el usuario antes de la primera prueba) |
| Hacer un ticket o una especificación completos | `implement`, `implement-spec` (ver nota de subagentes) |
| Revisar cambios contra estándares y contra la especificación | `code-review-matt` |
| Un error difícil de reproducir | `diagnosing-bugs` |
| Mejorar la arquitectura | `codebase-design` (vocabulario), `improve-codebase-architecture` (informe) |
| Vocabulario del negocio y decisiones | `domain-modeling` |
| Mirar hacia atrás después de un trabajo | `retro` |
| No sé cuál usar | `ask-matt` |

## Verificar

Las skills de Matt dejan la verificación al proyecto: corre siempre las pruebas que pida el
`CLAUDE.md` (y su resumen al usuario), aunque la skill no las mencione.
