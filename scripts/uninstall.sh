#!/bin/sh

set -eu

usage() {
	printf '%s\n' 'usage: scripts/uninstall.sh [--prefix <directory>] [--purge-local-data]'
}

prefix="${HOME}/.local"
purge=false
while [ "$#" -gt 0 ]; do
	case "$1" in
		--prefix)
			[ "$#" -ge 2 ] || { usage >&2; exit 2; }
			prefix=$2
			shift 2
			;;
		--purge-local-data)
			purge=true
			shift
			;;
		--help)
			usage
			exit 0
			;;
		*)
			usage >&2
			exit 2
			;;
	esac
done

case "$prefix" in
	""|/)
		printf '%s\n' 'refusing an empty or root install prefix' >&2
		exit 2
		;;
esac
binary="$prefix/bin/zsh-git-good"
plugin="$prefix/share/zsh-git-good/zsh-git-good.plugin.zsh"
if [ -x "$binary" ]; then
	"$binary" daemon stop >/dev/null 2>&1 || true
fi
rm -f -- "$binary" "$plugin" "$prefix/share/zsh-git-good/LICENSE" "$prefix/share/zsh-git-good/THIRD_PARTY_NOTICES"
rmdir "$prefix/share/zsh-git-good" 2>/dev/null || true
rmdir "$prefix/share" 2>/dev/null || true
rmdir "$prefix/bin" 2>/dev/null || true

remove_product_directory() {
	directory=$1
	case "$directory" in
		*/zsh-git-good) ;;
		*)
			printf '%s\n' "refusing unexpected data path: $directory" >&2
			return 1
			;;
	esac
	[ -e "$directory" ] && rm -rf -- "$directory"
}

if [ "$purge" = true ]; then
	home=${HOME:?HOME is required to purge local data}
	remove_product_directory "${XDG_CACHE_HOME:-$home/.cache}/zsh-git-good"
	remove_product_directory "${XDG_STATE_HOME:-$home/.local/state}/zsh-git-good"
	remove_product_directory "${XDG_DATA_HOME:-$home/.local/share}/zsh-git-good"
	remove_product_directory "${XDG_CONFIG_HOME:-$home/.config}/zsh-git-good"
	if [ -n "${XDG_RUNTIME_DIR:-}" ]; then
		remove_product_directory "$XDG_RUNTIME_DIR/zsh-git-good"
	fi
	printf '%s\n' 'removed zsh-git-good local data after explicit purge request'
fi
printf '%s\n' 'removed installed zsh-git-good files; remove its source line from .zshrc'
