alias vi="nvim"
alias vim="nvim"

alias ls="ls --color=tty"

eval "$(zoxide init zsh)"

function git_branch_name {
	_branch=$(git branch --show-current 2> /dev/null)

	if [[ $? -eq 0 ]]; then
		echo $_branch
	fi
}

if [[ -e "$ZDOTDIR/extends/deployment_scripts" ]]; then
	source "$ZDOTDIR/extends/deployment_scripts"
fi

# completions
autoload -U compinit
compinit

# auto suggestions
if [[ -z "$HOMBREW_PREFIX" ]]; then
	_suggestions_path="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

	if [[ -e "$_suggestions_path" ]]; then
		export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

		source "$_suggestions_path"
	fi
fi

