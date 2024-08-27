. "$HOME/.cargo/env"

function set_pnpm_path {
  if [[ -z "$PNPM_HOME" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
  fi
}

function set_editor_value {
  if [[ -z "$EDITOR" ]]; then
    export EDITOR="nvim"
  fi
}

set_pnpm_path
set_editor_value

unfunction set_pnpm_path
unfunction set_editor_value

