alias vi="nvim"
alias vim="nvim"

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

