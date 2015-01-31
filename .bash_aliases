#
# aliases for package management
#
alias agu='sudo apt-get update'
alias agd='sudo apt-get dist-upgrade'
alias agi='sudo apt-get install'
alias agc='sudo apt-get clean'
alias agr='sudo apt-get remove'
alias ags='apt-cache search'
alias agsh='apt-cache show'
alias agac='sudo apt-get autoclean'
alias agar='sudo apt-get autoremove'

#
# resource management
#
alias ducks='(shopt -s dotglob; du -cks *; shopt -u dotglob) | sort -rn | head -11'

alias pom="find . -name pom.xml -not -regex '.*/target/.*'"
