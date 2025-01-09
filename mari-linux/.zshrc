#
# Extensions
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/Projects/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $HOME/Projects/evalcache/evalcache.plugin.zsh

_evalcache starship init zsh
_evalcache zoxide init zsh
# Path
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/share/bob/nvim-bin
export PATH=$PATH:/usr/local/go/bin

# Environment Paths
## Pico
export PICO_SDK_PATH=/home/maripasa/Projects/pico-setup/pico/pico-sdk
export PICO_EXAMPLES_PATH=/home/maripasa/Projects/pico-setup/pico/pico-examples
export PICO_EXTRAS_PATH=/home/maripasa/Projects/pico-setup/pico/pico-extras
export PICO_PLAYGROUND_PATH=/home/maripasa/Projects/pico-setup/pico/pico-playground

## Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

## Go
export PATH=$PATH:/usr/local/go/bin

## Zig
export PATH=$PATH:$HOME/Projects/zig-linux-x86_64-0.14.0-dev.2615+a7a5f3506

# Environment Variables
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export RUSTC_WRAPPER=sccache

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt hist_ignore_dups
setopt share_history
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Key Bindings
bindkey '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
bindkey '^[OA' history-search-backward
bindkey '^[OB' history-search-forward

# start with cd
chpwd() {
	echo "$PWD" > ~/.last_dir
} 

# Aliases
alias cd="z"
alias ls="exa"
alias du="dust"
alias cat="bat"
alias grep="rg"
alias pomo="porsmo pomodoro custom 50m 5m 15m"
alias wiki="wiki-tui"
alias connect="nmcli device wifi connect"

copy() {
	cat "$1" | xclip -selection clipboard
}
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

