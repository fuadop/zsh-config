alias vi="nvim"
alias vim="nvim"

alias ls="ls --color=tty"
alias grep="grep --color=tty"
alias rgrep="grep --color=tty -r"
alias gorepl="yaegi"

setopt auto_cd

# functions

function get_parent_cmd {
	pid=$(echo $$)
	ppid=$(ps -p $pid -o ppid | tail -n 1)
	ppid_cmd=$(ps -p $ppid -o comm | tail -n 1)

	echo $ppid_cmd
}

function git_branch_name {
	_branch=$(git branch --show-current 2> /dev/null)

	if [[ $? -eq 0 ]]; then
		echo $_branch
	fi
}

function register_preferred_prompt {
	local _p=""

	_p+="%F{63}[%f"
	_p+="%F{8}%l%f"
	_p+="%F{11}@%f"
	_p+="%F{13}%m%f"
	_p+="%F{63}]%f"
	_p+=" %c "
	_p+="%B%F{%(?.green.red)}%#%f%b"

	PROMPT="$_p "
	RPROMPT="%F{8}%*%f"
}

# prompt
register_preferred_prompt
unfunction register_preferred_prompt

if [[ -e "$ZDOTDIR/extends/deployment_scripts" ]]; then
	source "$ZDOTDIR/extends/deployment_scripts"
fi

# hooks

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# completions
autoload -U compinit
compinit

zmodload -i zsh/complist

zstyle ':completion:*' menu select

# key bindings
bindkey -e # prefer emacs bindings

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

autoload -U edit-command-line
zle -N edit-command-line

bindkey "^X" edit-command-line

tmux -V &> /dev/null
if [[ $? -eq 0 ]]; then
	function clear_tmux_scrollback_buffer {
		if [[ $(get_parent_cmd) = *"tmux" ]]; then
			tmux clear-history
		fi
	}

	zle -N clear_tmux_scrollback_buffer
	bindkey "^[^L" clear_tmux_scrollback_buffer
fi

# auto suggestions
if [[ "$HOMEBREW_PREFIX" ]]; then
	_suggestions_path="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

	if [[ -e "$_suggestions_path" ]]; then
		export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

		source "$_suggestions_path"
	fi
fi

# syntax highlighting
if [[ "$HOMEBREW_PREFIX" ]]; then
	_suggestions_path="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

	if [[ -e "$_suggestions_path" ]]; then
		source "$_suggestions_path"
	fi
fi

# predictive history search
if [[ "$HOMEBREW_PREFIX" ]]; then
	_suggestions_path="$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"

	if [[ -e "$_suggestions_path" ]]; then
		source "$_suggestions_path"

		bindkey '^[[A' history-substring-search-up
		bindkey '^[[B' history-substring-search-down
	fi
fi

# fzf
source <(fzf --zsh)

