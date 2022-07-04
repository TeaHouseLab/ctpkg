function list
    switch $package_manager
        case apt aptitude
            apt list $argv
        case pacman
            $package_manager -Sl $argv
        case yum dnf apk opkg
            $package_manager list $argv
        case xbps
            $package_manager-query -Rs '*' $argv
        case '*'
            logger 5 "No support package manager detected"
    end
end
