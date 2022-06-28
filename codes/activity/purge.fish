function purge
    switch $package_manager
        case apt
            sudo $package_manager purge $argv
            sudo $package_manager autoremove --purge
        case aptitude
            sudo $package_manager purge $argv
        case pacman
            sudo $package_manager -Rsn $argv
        case apk
            sudo $package_manager del $argv
        case dnf yum
            sudo $package_manager remove $argv
        case xbps
            sudo $package_manager-remove -R $argv
        case '*'
            logger 5 "No support package manager detected"
    end
end
