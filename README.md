[Config Precedence](https://zsh.sourceforge.io/Doc/Release/Files.html#Files)

/etc/zshenv
```zsh
function set_config_path {
  if [[ -z "$XDG_CONFIG_HOME" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
  fi
}

function set_zsh_files_path {
  if [[ -z "$ZDOTDIR" ]]; then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
  fi
}

set_config_path
set_zsh_files_path

unfunction set_config_path
unfunction set_zsh_files_path

```


