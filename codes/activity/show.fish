function show
    switch $package_manager
        case apt aptitude
            $package_manager show $argv
        case pacman
            $package_manager -Si $argv
        case apk dnf yum
            $package_manager info $argv
        case xbps
            $package_manager-query -RS $argv
        case '*'
            logger 4 "No support package manager detected"
    end
end
