function upgrade
    switch $package_manager
        case apt
            sudo $package_manager update
            sudo $package_manager upgrade $argv
            sudo $package_manager autoremove --purge -y
        case aptitude apk
            sudo $package_manager update $argv
            sudo $package_manager upgrade $argv
        case pacman
            sudo $package_manager -Syu $argv
        case dnf yum
            sudo $package_manager upgrade $argv
        case xbps
            sudo $package_manager-install -Su
        case '*'
            logger 4 "No support package manager detected"
    end
end
