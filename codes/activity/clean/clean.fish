function clean
    detectos
    switch $package_manager
        case apt aptitude 
            sudo $package_manager clean $argv
        case pacman
            sudo $package_manager -Scc $argv
        case apk
            logger 4 "$prefix No Such function in alpine apk"
        case dnf
            sudo $package_manager clean all $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end
