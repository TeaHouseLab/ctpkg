function search
    detectos
    switch $package_manager
        case apt aptitude apk dnf
            $package_manager search $argv
        case pacman
            $package_manager -Ss $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end
