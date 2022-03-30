function purge
    switch $package_manager
        case apt
            sudo $package_manager purge $argv
            sudo $package_manager autoremove --purge
        case aptitude
            sudo $package_manager purge $argv
        case pacman
            sudo $package_manager -Rn $argv
            sudo $package_manager -Rn (pacman -Qtdq)
        case apk
            sudo $package_manager del $argv
        case dnf
            sudo $package_manager remove $argv
        case xbps
            sudo $package_manager-remove -R $argv
        case '*'
            logger 4 "No support package manager detected"
    end
end
