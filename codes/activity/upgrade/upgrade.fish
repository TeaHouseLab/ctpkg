function upgrade
    detectos
    switch $package_manager
        case apt aptitude
            sudo $package_manager update $argv
            sudo $package_manager upgrade $argv
        case pacman
            sudo $package_manager -Syu $argv
        case apk
            sudo $package_manager update $argv
            sudo $package_manager upgrade $argv
        case dnf
            sudo $package_manager update $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end
