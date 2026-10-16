alias cd..='cd ..'

alias etcgit='sudo git --git-dir=/var/lib/etcgit --work-tree=/etc'

alias hcurl='curl -s -D - -o /dev/null'

alias k=kubectl

alias lb="ls -alF --block-size=\"'1\""

alias lg="lazygit"

alias qr='qrencode -l M -t ansiutf8'

alias portainer='open https://localhost:9443/'

alias pubip='dig ANY -4 +short @resolver2.opendns.com myip.opendns.com'
alias pubip6='dig ANY -6 +short @resolver2.opendns.com myip.opendns.com'

alias syncpass='odrive -d ~/Documents -f NewDatabase.kdbx https://1drv.ms/u/c/fe3df9b4c0f58eaf/Ea-O9cC0-T0ggP6lIQAAAAABJ2D_wef9o6KDi-ict_L4Vg?e=kERbbK'

alias tls-test='nmap --script ssl-enum-ciphers -p 443'
