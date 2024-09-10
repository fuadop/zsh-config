eval "$(/opt/homebrew/bin/brew shellenv)"

function add_bin_path {
  export PATH="$PATH:$1"
}

function remove_bin_path {
	local _pattern=$(echo $1 | sed 's/\//\\\//g')
	export PATH=$(echo $PATH | sed "s/:$_pattern//g")
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

function move_homebrew_bin_path_last {
	# prefer system packages over homebrew's version, e.g python3

	if [[ "$PATH" ]]; then
		_homebrew_paths=$(echo $PATH |
			awk '
				BEGIN { FS=":" }
				{
					for (i=1; i<=NF;i++) {
						if ($i ~ /[Hh]omebrew/) {
							printf "%s:", $i
						}
					} 
				}
			'
		)

		_non_homebrew_paths=$(echo $PATH |
			awk '
				BEGIN { FS=":" }
				{
					for (i=1; i<=NF;i++) {
						if ($i !~ /[Hh]omebrew/) {
							printf "%s:", $i
						}
					} 
				}
			'
		)

		export PATH="$_non_homebrew_paths${_homebrew_paths::-1}"
	fi
}

move_homebrew_bin_path_last

if [[ "$PNPM_HOME" ]]; then
	add_bin_path "$PNPM_HOME"
fi

add_bin_path "/opt/homebrew/opt/libpq/bin"
add_bin_path "$HOME/Library/Python/3.9/bin"
add_bin_path "/opt/homebrew/opt/e2fsprogs/bin"
add_bin_path "/opt/homebrew/opt/e2fsprogs/sbin"
add_bin_path "/opt/homebrew/opt/mysql-client/bin"

unfunction move_homebrew_bin_path_last

