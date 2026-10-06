#!/usr/bin/env bash
# Copia las skills de este repositorio a .claude/ de un proyecto.
#
# Uso:  bash instalar.sh <carpeta-del-proyecto> [qt|web|todo]
#   qt   (por defecto) app de escritorio PySide6/PyQt: las skills de diseño y
#        animación que aplican a escritorio, impeccable, taste-skill (las tres
#        generales) y las traducciones a Qt (diseno-qt, impeccable-qt, taste-qt).
#   web  sitio o app web: impeccable, las de Emil menos Swift y Expo, y las de
#        taste-skill que no necesitan generar imágenes.
#   todo todas.
#
# impeccable se copia con sus 4 subagentes (.claude/agents/) pero sin hooks;
# en proyectos web se activan con «/impeccable hooks on».
set -euo pipefail

destino="${1:?Uso: bash instalar.sh <carpeta-del-proyecto> [qt|web|todo]}"
perfil="${2:-qt}"
aqui="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
emil="$aqui/plugins/emil-design/skills"
qt="$aqui/plugins/diseno-qt/skills"
imp="$aqui/proyecto/impeccable"
taste="$aqui/plugins/taste-skill/skills"

case "$perfil" in
  qt)   skills=(emil-design-eng animate review-animations improve-animations find-animation-opportunities
                animation-vocabulary apple-design break-ui) ; gustos=(taste-skill redesign-skill output-skill) ; con_qt=1 ;;
  web)  skills=(emil-design-eng animate review-animations improve-animations find-animation-opportunities
                animation-vocabulary apple-design break-ui mobile-native pick-ui-library prototype ask-sonner) ; con_qt=0
        gustos=(taste-skill redesign-skill output-skill minimalist-skill soft-skill brutalist-skill gpt-tasteskill stitch-skill) ;;
  todo) skills=($(ls "$emil")) ; gustos=($(ls "$taste")) ; con_qt=1 ;;
  *)    echo "Perfil desconocido: $perfil (usa qt, web o todo)" >&2; exit 1 ;;
esac

copiar() {  # copiar <origen> <nombre>
  rm -rf "$destino/.claude/skills/$2"
  cp -r "$1" "$destino/.claude/skills/$2"
}

mkdir -p "$destino/.claude/skills" "$destino/.claude/agents"
for s in "${skills[@]}"; do copiar "$emil/$s" "$s"; done

for s in "${gustos[@]}"; do copiar "$taste/$s" "$s"; skills+=("$s"); done

copiar "$imp/skills/impeccable" impeccable
cp "$imp"/agents/*.md "$destino/.claude/agents/"
skills+=(impeccable)

if [ "$con_qt" = 1 ]; then
  for s in diseno-qt impeccable-qt taste-qt; do copiar "$qt/$s" "$s"; skills+=("$s"); done
fi

# Avisos de licencia junto a las copias: MIT (Emil Kowalski y Leonxlnx) y Apache 2.0 (impeccable).
ls "$destino/.claude/skills"/LICENSE-taste* >/dev/null 2>&1 \
  || cp "$aqui/plugins/taste-skill/LICENSE" "$destino/.claude/skills/LICENSE-taste-skill"
ls "$destino/.claude/skills"/LICENSE-emil* >/dev/null 2>&1 \
  || cp "$aqui/plugins/emil-design/LICENSE" "$destino/.claude/skills/LICENSE-emil-kowalski-skills"
cp "$imp/LICENSE" "$destino/.claude/skills/impeccable/LICENSE"
cp "$imp/NOTICE.md" "$destino/.claude/skills/impeccable/NOTICE.md"

echo "Instaladas en $destino/.claude/skills: ${skills[*]}"
echo "Subagentes de impeccable en $destino/.claude/agents"
