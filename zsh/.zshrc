# {{{ p10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

DISTRO_NAME=$(lsb_release -i | awk 'NF>1{print $NF}' -)

# {{{ Plugins
source ~/.zplug/init.zsh

# Let zplug manage itself
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Change ZSH theme
zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "marzocchi/zsh-notify"

# Oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh

# Distro specific

# SSH
zplug "hkupty/ssh-agent"

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
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2

# Then, source plugins and add commands to $PATH
zplug load
# }}}

# Show system configuration
screenfetch

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

# Set up notifications
zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"

# History
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
# }}}

# Load kitty after completion loads
autoload -Uz compinit colors
compinit -d
kitty + complete setup zsh | source /dev/stdin

colors


bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
