function update
    switch $package_manager
        case apt aptitude
            sudo $package_manager update $argv
        case pacman
            sudo $package_manager -Sy $argv
        case apk
            sudo $package_manager update $argv
        case dnf
            sudo $package_manager check-update $argv
        case xbps
            sudo $package_manager-install -S $argv
        case '*'
            logger 4 "No support package manager detected"
    end
end
