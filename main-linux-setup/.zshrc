function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo '('$branch') > '
  fi
}

# Custom PATH setup
export PATH=$HOME/.local/bin:$HOME/.nvm/versions/node/v20.17.0/bin:$HOME/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/:/usr/local/go/bin
export PATH=$PATH:/opt/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin

# Pico SDK and toolchain paths
export PICO_SDK_PATH=~/pico/pico-sdk/
export PICO_TOOLCHAIN_PATH=/opt/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt hist_ignore_dups
setopt share_history

PROMPT="( $(git_branch_name)%F{blue}%1~%f @ %F{cyan}%m%f, %F{green}<%n>%f ) ; "

autoload -U history-search-end
autoload -U compinit

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[OA' history-search-backward
bindkey '^[OB' history-search-forward

CASE_SENSITIVE="false"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
