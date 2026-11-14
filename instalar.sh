#!/bin/sh
# Instala la skill filigrana para Claude Code en esta máquina (todos los proyectos).
#
#   curl -fsSL https://raw.githubusercontent.com/BilalGates/filigranas/main/instalar.sh | sh
#
# Repetirlo actualiza. Clona el repo en $FILIGRANAS_DIR (por defecto ~/.filigranas) y enlaza
# la skill en ~/.claude/skills (o $CLAUDE_CONFIG_DIR/skills): un `git pull` del repo la actualiza.
# ponytail: sin Windows (necesita enlaces simbólicos); allí, copiar la carpeta a mano.
set -eu

repo="${FILIGRANAS_DIR:-$HOME/.filigranas}"
skills="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"
origen="$repo/kit-agentes/.agents/skills/filigrana"
destino="$skills/filigrana"

command -v git >/dev/null || { echo "!!  falta git" >&2; exit 1; }

if [ -d "$repo/.git" ]; then
  git -C "$repo" pull -q --ff-only
else
  git clone -q --depth 1 https://github.com/BilalGates/filigranas.git "$repo"
fi

mkdir -p "$skills"
if [ -e "$destino" ] && [ ! -L "$destino" ]; then
  echo "!!  $destino ya existe y no es un enlace: no se pisa. Bórralo y repite." >&2
  exit 1
fi
ln -sfn "$origen" "$destino"

echo "ok  filigrana en $destino"
echo "    Abre Claude Code y pide, por ejemplo: «filigrana, diseña la landing»."
command -v node >/dev/null || echo "    Aviso: los scripts de la skill (detectar-slop, delegar) necesitan Node 18+."
