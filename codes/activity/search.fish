function search
    switch $package_manager
        case apt aptitude apk dnf yum
            $package_manager search $argv
        case pacman
            $package_manager -Ss $argv
        case xbps
            $package_manager-query -Rs $argv
        case '*'
            logger 4 "No support package manager detected"
    end
end
