eval "$(/opt/homebrew/bin/brew shellenv)"

function add_bin_path {
  export PATH="$PATH:$1"
}

function remove_bin_path {
	local _pattern=$(echo $1 | sed 's/\//\\\//g')
	export PATH=$(echo $PATH | sed "s/:$_pattern//g")
}

if [[ "$PNPM_HOME" ]]; then
	add_bin_path "$PNPM_HOME"
fi

add_bin_path "$(go env GOPATH)/bin"

if [[ "$HOME" ]]; then
	add_bin_path "$HOME/.ghcup/bin"
fi

if [[ $(uname -s) == "Darwin" ]]; then
	add_bin_path "/opt/homebrew/opt/libpq/bin"
	add_bin_path "/opt/homebrew/opt/python/bin"
	add_bin_path "/opt/homebrew/opt/python/libexec/bin"
	add_bin_path "/opt/homebrew/opt/binutils/bin"
	add_bin_path "/opt/homebrew/opt/e2fsprogs/bin"
	add_bin_path "/opt/homebrew/opt/e2fsprogs/sbin"
	add_bin_path "/opt/homebrew/opt/mysql@8.4/bin"
	add_bin_path "/Applications/ImHex.app/Contents/MacOS"
fi

