# {{{ p10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi
# }}}

DISTRO_NAME=$(lsb_release -i | awk 'NF>1{print $NF}' -)

# {{{ Plugins
source ~/.zplug/init.zsh

# Let zplug manage itself
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Change ZSH theme
#zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

zplug "marzocchi/zsh-notify"

# Oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh

# Distro specific

# SSH
zplug "hkupty/ssh-agent"

# Vi mode keybinds
zplug "okapia/zsh-viexchange"

# Completion sources
zplug "zpm-zsh/ssh"
zplug "spwhitt/nix-zsh-completions"
zplug "sirhc/op.plugin.zsh"
zplug "srijanshetty/zsh-pandoc-completion"
zplug "srijanshetty/zsh-pip-completion"

# Fish-like shell plugins
zplug "changyuheng/zsh-interactive-cd"
zplug "psprint/zsh-navigation-tools"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
#zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zdharma/fast-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2

# Then, source plugins and add commands to $PATH
zplug load
# }}}

# Source local fzf completion bindings
if [ $DISTRO_NAME != "NixOS" ]; then
  source /usr/share/fzf/completion.zsh
  source /usr/share/fzf/key-bindings.zsh
fi

# Show system configuration
#screenfetch
neofetch

zle

# {{{ Options
setopt correct                         # Auto correct mistakes
setopt extendedglob                    # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                      # Case insensitive globbing
setopt rcexpandparam                   # Array expension with parameters
setopt numericglobsort                 # Sort filenames numerically when it makes sense
setopt appendhistory                   # Immediately append history instead of overwriting
setopt histignorealldups               # If a new command is a duplicate, remove the older one
setopt autocd                          # if only directory path is entered, cd there.

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Enable menu select for completions
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
zmodload zsh/complist

# Enaable tcp ssh connections
zmodload zsh/net/tcp

# Set up notifications
zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"

# Turn off all beeps
unsetopt BEEP
# Turn off autocomplete beeps
unsetopt LIST_BEEP

# History
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
# }}}

# {{{ Terminal specific

# Load kitty after completion loads
autoload -Uz compinit colors
compinit -d
kitty + complete setup zsh | source /dev/stdin
colors

# }}}

# {{{ Spaceship theme
#export SPACESHIP_USER_SHOW=always
#export SPACESHIP_HOST_SHOW=always
eval spaceship_vi_mode_enable
#export SPACESHIP_PROMPT_SEPARATE_LINE=false
export SPACESHIP_TIME_SHOW=true

# }}}

# {{{ Vi mode + Keybinds

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -v "^?" backward-delete-char

# Change cursor shape for different vi modes
zle-keymap-select() {
if [[ ${KEYMAP} == vicmd ]] ||
  [[ $1 = "block" ]]; then
  echo -ne "\e[1 q"
elif [[ ${KEYMAP} == main ]] ||
  [[ ${KEYMAP} == viins ]] ||
  [[ ${KEYMAP} = '' ]] ||
  [[ $1 = "beam" ]]; then
  echo -ne "\e[5 q"
fi
}

zle -N zle-keymap-select

zle-line-init() {
zle -K viins
echo -ne "\e[5 q"
}

zle -N zle-line-init

echo -ne "\e[5 q"
preexec() {
  echo -ne "\e[5 q"
}

#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down

autoload edit-command-line; zle -N edit-command-line
bindkey "^e" edit-command-line

# }}}

# {{{ Aliases
alias cp="cp -i"                      # Confirm before overwriting something
alias df='df -h'                      # Human-readable sizes
alias free='free -m'                  # Show sizes in MB
alias btop="bpytop"                   # Pretty top
alias top="htop"                      # Always use htop

# Exa instead of ls
alias ls="exa --icons"                # Use exa
alias l="exa --icons --long"          # Display extended details
alias lt="exa --icons --long --tree"  # Tree with extended details
alias la="exa --icons --long --all"   # Display extended details with all
alias lat="exa --icons --long --all"  # Tree with extended details with all
# }}}

# {{{ Distro specific


# If distro is based on arch linux

command_not_found_handler() {
  if [ $DISTRO_NAME != "Arch" ]; then
    return 127
  fi
  local pkgs cmd="$1" files=()
  printf 'zsh: command not found: %s' "$cmd" # print command not found asap, then search for packages
  files=(${(f)"$(pacman -F --machinereadable -- "/usr/bin/${cmd}")"})
  if (( ${#files[@]} )); then
    printf '\r%s may be found in the following packages:\n' "$cmd"
    local res=() repo package version file
    for file in "$files[@]"; do
      res=("${(0)file}")
      repo="$res[1]"
      package="$res[2]"
      version="$res[3]"
      file="$res[4]"
      printf '  %s/%s %s: /%s\n' "$repo" "$package" "$version" "$file"
    done
  else
    printf '\n'
  fi
  return 127
}

# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
