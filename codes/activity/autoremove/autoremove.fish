function autoremove
    switch $package_manager
        case apt
            sudo $package_manager autoremove --purge $argv
        case aptitude
            sudo $package_manager -o Aptitude::Delete-Unused=1 install $argv
        case pacman
            sudo $package_manager -Rn (pacman -Qtdq) $argv
        case apk
            logger 4 'No Such function in alpine apk'
        case dnf
            sudo $package_manager autoremove $argv
        case xbps
            sudo $package_manager-remove -Oo $argv
        case '*'
            logger 4 "No support package manager detected"
    end
end
