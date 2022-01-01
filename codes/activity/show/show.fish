function show
    detectos
    switch $package_manager
        case apt aptitude
            $package_manager show $argv
        case pacman
            $package_manager -Si $argv
        case apk dnf
            $package_manager info $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end
