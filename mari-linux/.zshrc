# Custom PATH setup
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/share/bob/nvim-bin

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/Projects/zsh-autocomplete/zsh-autocomplete.plugin.zsh

export PICO_SDK_PATH=/home/maripasa/Projects/pico-setup/pico/pico-sdk
export PICO_EXAMPLES_PATH=/home/maripasa/Projects/pico-setup/pico/pico-examples
export PICO_EXTRAS_PATH=/home/maripasa/Projects/pico-setup/pico/pico-extras
export PICO_PLAYGROUND_PATH=/home/maripasa/Projects/pico-setup/pico/pico-playground

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

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
bindkey '^[OA' history-search-backward

bindkey '^[OB' history-search-forward

CASE_SENSITIVE="false"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export RUSTC_WRAPPER=sccache

eval "$(starship init zsh)"

alias ls="exa"
alias du="dust"
alias cat="bat"
alias grep="rg"
alias pomo="porsmo pomodoro custom 50m 5m 15m"
alias wiki="wiki-tui"
