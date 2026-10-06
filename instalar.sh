#!/usr/bin/env bash
# Copia las skills de este repositorio a .claude/skills/ de un proyecto.
#
# Uso:  bash instalar.sh <carpeta-del-proyecto> [qt|web|todo]
#   qt   (por defecto) app de escritorio PySide6/PyQt: las skills de diseño y
#        animación que aplican a escritorio + diseno-qt (la traducción a Qt).
#   web  sitio o app web: todas las de Emil menos Swift y Expo.
#   todo todas.
set -euo pipefail

destino="${1:?Uso: bash instalar.sh <carpeta-del-proyecto> [qt|web|todo]}"
perfil="${2:-qt}"
aqui="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
emil="$aqui/plugins/emil-design/skills"

case "$perfil" in
  qt)   skills=(emil-design-eng animate review-animations improve-animations find-animation-opportunities
                animation-vocabulary apple-design break-ui) ; con_qt=1 ;;
  web)  skills=(emil-design-eng animate review-animations improve-animations find-animation-opportunities
                animation-vocabulary apple-design break-ui mobile-native pick-ui-library prototype ask-sonner) ; con_qt=0 ;;
  todo) skills=($(ls "$emil")) ; con_qt=1 ;;
  *)    echo "Perfil desconocido: $perfil (usa qt, web o todo)" >&2; exit 1 ;;
esac

mkdir -p "$destino/.claude/skills"
for s in "${skills[@]}"; do
  rm -rf "$destino/.claude/skills/$s"
  cp -r "$emil/$s" "$destino/.claude/skills/$s"
done
if [ "$con_qt" = 1 ]; then
  rm -rf "$destino/.claude/skills/diseno-qt"
  cp -r "$aqui/plugins/diseno-qt/skills/diseno-qt" "$destino/.claude/skills/diseno-qt"
  skills+=(diseno-qt)
fi
# Aviso de licencia (MIT) de las skills de Emil Kowalski junto a las copias.
cp "$aqui/plugins/emil-design/LICENSE" "$destino/.claude/skills/LICENSE-emil-kowalski-skills"

echo "Instaladas en $destino/.claude/skills: ${skills[*]}"
