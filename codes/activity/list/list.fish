function list
    detectos
    switch $package_manager
        case apt aptitude
            apt list --installed $argv
        case pacman
            $package_manager -Qq $argv
        case apk
            $package_manager list $argv
        case dnf
            $package_manager list installed $argv
        case '*'
          logger 4 "$prefix No support package manager detected"
    end
end
