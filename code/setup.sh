
set -o errexit -o pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )"

case "$( uname -s )" in
  Linux*)
    cp -f "$SCRIPT_DIR/settings.json" "$HOME/.config/Code/User/settings.json"
    ;;
  Darwin*)
    cp -f "$SCRIPT_DIR/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    ;;
  *)
    exit 1
    ;;
esac

while IFS= read -r __ext || [[ -n "$__ext" ]]; do
  [[ -z "$__ext" || "$__ext" == \#* ]] && continue
  code --install-extension "$__ext"
done < "$SCRIPT_DIR/extensions.txt"
unset __ext

unset SCRIPT_DIR
