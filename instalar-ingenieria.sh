#!/usr/bin/env bash
# Copia las 27 skills de ingeniería de Matt Pocock (estables, las del plugin oficial) y la
# adaptación ingenieria-python a .claude/skills de un proyecto.
#
# Uso:  bash instalar-ingenieria.sh <carpeta-del-proyecto>
#
# Cambios al copiar (las del plugin quedan sin modificar):
#   code-review -> code-review-matt   (no tapar el /code-review de Claude Code)
#   prototype   -> prototype-matt     (solo si el proyecto ya tiene otra «prototype», p. ej. la de Emil)
# y se actualizan las referencias entre skills a esos nombres.
set -euo pipefail

destino="${1:?Uso: bash instalar-ingenieria.sh <carpeta-del-proyecto>}"
aqui="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
matt="$aqui/plugins/mattpocock-skills/skills"
skills_dir="$destino/.claude/skills"
mkdir -p "$skills_dir"

renombres=(code-review)
if [ -d "$skills_dir/prototype" ] && ! grep -q "Matt Pocock\|mattpocock" -r "$skills_dir/prototype" 2>/dev/null; then
  renombres+=(prototype)
fi

instaladas=()
for ruta in "$matt"/*/*/; do
  nombre="$(basename "$ruta")"
  final="$nombre"
  for r in "${renombres[@]}"; do [ "$nombre" = "$r" ] && final="$nombre-matt"; done
  rm -rf "$skills_dir/$final"
  cp -r "$ruta" "$skills_dir/$final"
  rm -rf "$skills_dir/$final/agents"   # agents/openai.yaml es solo para Codex
  instaladas+=("$final")
done

# Referencias entre skills a los nombres nuevos («code-review» → «code-review-matt»).
for r in "${renombres[@]}"; do
  for s in "${instaladas[@]}"; do
    find "$skills_dir/$s" -type f -name '*.md' -print0 | xargs -0 sed -i -E \
      "s/(^|[^-a-zA-Z0-9])$r([^-a-zA-Z0-9]|\$)/\1$r-matt\2/g"
  done
done

rm -rf "$skills_dir/ingenieria-python"
cp -r "$aqui/plugins/ingenieria-python/skills/ingenieria-python" "$skills_dir/ingenieria-python"
instaladas+=(ingenieria-python)
cp "$aqui/plugins/mattpocock-skills/LICENSE" "$skills_dir/LICENSE-mattpocock-skills.md"

echo "Instaladas en $skills_dir: ${instaladas[*]}"
