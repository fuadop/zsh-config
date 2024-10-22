alias vi="nvim"
alias vim="nvim"

alias ls="ls --color=tty"
alias grep="grep --color=tty"
alias rgrep="grep --color=tty -r"

setopt auto_cd

# functions

function git_branch_name {
	_branch=$(git branch --show-current 2> /dev/null)

	if [[ $? -eq 0 ]]; then
		echo $_branch
	fi
}

function attach_i686_environ {
	export TARGET="i686-elf"
	export PREFIX="$HOME/Developer/cross-compiler/opt/cross"

	add_bin_path "$PREFIX/bin"
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

function detach_i686_environ {
	if [[ "$TARGET" = "i686-elf" ]]; then
		unset TARGET

		if [[ "$PREFIX" ]]; then
			remove_bin_path "$PREFIX/bin"

			unset PREFIX
		fi
	fi
}

# prompt
register_preferred_prompt
unfunction register_preferred_prompt

# i686-elf bin & gcc binaries
function toggle_i686_environ {
	if [[ $PWD = "$HOME/Developer"* ]] || [[ $PWD = *"OS"* ]]; then
		attach_i686_environ
	else
		detach_i686_environ
	fi
}

if [[ -e "$ZDOTDIR/extends/deployment_scripts" ]]; then
	source "$ZDOTDIR/extends/deployment_scripts"
fi

# hooks

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

toggle_i686_environ

if [[ $chpwd_functions[(Ie)toggle_i686_environ] -eq 0 ]]; then
	chpwd_functions+=(toggle_i686_environ)
fi

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

