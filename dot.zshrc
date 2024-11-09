################################################################################
# zsh pre-setup operations

autoload -Uz +X compinit
# -U disabled alias-expansion
# -z zsh-style autoloading
# +X suppress execution at autoload


################################################################################
# ZSH command line completion

# ... Make path-completion case insensitive
# 1. case insensitive completion
# 2. case-insensitive partial-word completion
zstyle ':completion:*' matcher-list \
    'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
    'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# ... Make path-completion not show list but TAB through each choice
setopt MENU_COMPLETE
setopt NO_AUTO_LIST
setopt NO_LIST_BEEP


################################################################################
# MacPorts

if [[ -f /opt/local/bin/port ]]; then

    echo "Activating MacPorts"

    # Extend PATH (front) so it includes MacPorts if it exists
    if [[ -d /opt/local/sbin ]]; then
        export PATH=/opt/local/sbin:$PATH
    fi
    if [[ -d /opt/local/bin ]]; then
        export PATH=/opt/local/bin:$PATH
    fi

    # Extend MANPATH (front) so it includes MacPorts if it exists
    if [[ -d /opt/local/share/man ]]; then
        export MANPATH=/opt/local/share/man:$MANPATH
    fi

    # Extend INFOPATH (front) so it includes MacPorts if it exists
    if [[ -d /opt/local/share/info ]]; then
        export INFOPATH=/opt/local/share/info
    fi

    # MacPorts Graphviz
    if [[ -f /opt/local/bin/dot ]]; then
        export GRAPHVIZ_DOT=/opt/local/bin/dot
    fi

    # MacPorts Installer addition on 2020-11-14_at_11:56:25: adding an appropriate DISPLAY variable for use with MacPorts.
    export DISPLAY=:0
    # Finished adapting your DISPLAY environment variable for use with MacPorts.

fi


################################################################################
# Java

# if [[ -f /usr/libexec/java_home ]]; then
#     export JAVA_HOME=`/usr/libexec/java_home`
# fi

# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# export JAVA_TOOL_OPTIONS='-Djava.awt.headless=true'

# Using MacPorts OpenJDK8
# if [[ -d /Library/Java/JavaVirtualMachines/openjdk8/Contents/Home ]]; then
#     export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk8/Contents/Home
# fi

# Using asdf Java
# See "asdf" section below


################################################################################
# Gradle

# GRADLE_VERSION=6.7.1
# if [[ -d /opt/gradle/gradle-$GRADLE_VERSION/bin ]]; then
#     export PATH=$PATH:/opt/gradle/gradle-$GRADLE_VERSION/bin
# fi


################################################################################
# Android

if [[ -d $HOME/Library/Android/sdk ]]; then
    echo "Activating Android SDK"
    export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
    # avdmanager, sdkmanager
    export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
    # adb, logcat
    export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
    # emulator
    export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
fi


################################################################################
# JetBrains

JETBRAINS_TOOLBOX_SCRIPTS=~/Library/Application\ Support/JetBrains/Toolbox/scripts
if [[ -d $JETBRAINS_TOOLBOX_SCRIPTS ]]; then
    echo "Activating JetBrains Toolbox Scripts"
    export PATH=$PATH:$JETBRAINS_TOOLBOX_SCRIPTS
fi


################################################################################
# /opt/bin

# Extend PATH (rear) so it includes /opt/bin if it exists
if [[ -d /opt/bin ]]; then
    export PATH=$PATH:/opt/bin
fi


################################################################################
# $HOME/bin

# Extend PATH (front) so it includes $HOME/bin if it exists
if [[ -d $HOME/bin ]]; then
    export PATH=$HOME/bin:$PATH
fi


################################################################################
# asdf

if [[ -d $HOME/.asdf ]]; then
    echo "Activating asdf"
    
    source $HOME/.asdf/asdf.sh

    # append completions to fpath
    fpath=(${ASDF_DIR}/completions $fpath)
    
    # initialise completions with ZSH's compinit
    #compinit

    if ! [[ $(asdf where java 2>&1) =~ .*"No such plugin".* ]]; then
        export JAVA_HOME=$(asdf where java)
    fi
    
    # add man pages if they exist
    for app in `asdf current | awk '{print $1;}'`
    do
        ap=`asdf where $app`
        amp="$ap/share/man"
        if [[ -d $amp ]]; then
            export MANPATH=$amp:$MANPATH
        fi
    done
fi


################################################################################
# Git command line completion

MACPORTS_GIT_COMPLETION_ZSH=/opt/local/share/git/contrib/completion/git-completion.zsh
XCODE_GIT_COMPLETION_ZSH=/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.zsh
CLT_GIT_COMPLETION_ZSH=/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.zsh
if [[ -f $MACPORTS_GIT_COMPLETION_ZSH ]]; then
    echo "Activating $MACPORTS_GIT_COMPLETION_ZSH"
    zstyle ':completion:*:*:git:*' script $MACPORTS_GIT_COMPLETION_ZSH
elif [[ -f $XCODE_GIT_COMPLETION_ZSH ]]; then
    echo "Activating $XCODE_GIT_COMPLETION_ZSH"
    zstyle ':completion:*:*:git:*' script $XCODE_GIT_COMPLETION_ZSH
elif [[ -f $CLT_GIT_COMPLETION_ZSH ]]; then
    echo "Activating $CLT_GIT_COMPLETION_ZSH"
    zstyle ':completion:*:*:git:*' script $CLT_GIT_COMPLETION_ZSH
fi


################################################################################
# Show Git branch

# ... Load vcs information
autoload -Uz vcs_info
precmd() { vcs_info }

# ... Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats %F{green}' (%b)'%f

# ... Setup the prompt with git branch name
setopt PROMPT_SUBST
#PROMPT='%n@%m:%.${vcs_info_msg_0_} %% '
PROMPT=%F{blue}'[%.]'%f'${vcs_info_msg_0_} %% '


################################################################################
# My Stuffs

# Aliases
alias ls='ls -FG'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias llh='ls -lh'
alias shit='sudo $(fc -ln -1)'

# Post today's fortune (MacPorts)
if [[ -f /opt/local/bin/fortune ]]; then
    echo
    fortune
    echo
fi


################################################################################
# zsh post-setup operations

compinit
