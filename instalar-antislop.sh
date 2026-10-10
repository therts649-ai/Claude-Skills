#!/usr/bin/env bash
# Copia las 6 skills de anti-slop (miqdadbadjuber, sin modificar) y la adaptación antislop-qt a
# .claude/skills de un proyecto.
#
# Uso:  bash instalar-antislop.sh <carpeta-del-proyecto>
#
# Después agrega al CLAUDE.md del proyecto el bloque <!-- antislop:start --> … <!-- antislop:end -->
# (ver README): así su núcleo sabe que ya está instalado y no corre su asistente de instalación.
set -euo pipefail

destino="${1:?Uso: bash instalar-antislop.sh <carpeta-del-proyecto>}"
aqui="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_dir="$destino/.claude/skills"
mkdir -p "$skills_dir"

instaladas=()
for ruta in "$aqui"/plugins/anti-slop/skills/*/; do
  nombre="$(basename "$ruta")"
  rm -rf "$skills_dir/$nombre"
  cp -r "$ruta" "$skills_dir/$nombre"
  instaladas+=("$nombre")
done
rm -rf "$skills_dir/antislop-qt"
cp -r "$aqui/plugins/diseno-qt/skills/antislop-qt" "$skills_dir/antislop-qt"
instaladas+=(antislop-qt)
cp "$aqui/plugins/anti-slop/LICENSE" "$skills_dir/LICENSE-anti-slop.md"

echo "Instaladas en $skills_dir: ${instaladas[*]}"
