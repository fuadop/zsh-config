. "$HOME/.cargo/env"

function set_pnpm_path {
  if [[ -z "$PNPM_HOME" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
  fi
}

set_pnpm_path

unfunction set_pnpm_path

