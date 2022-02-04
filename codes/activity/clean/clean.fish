function clean
    switch $package_manager
        case apt aptitude
            sudo $package_manager clean $argv
        case pacman
            sudo $package_manager -Scc $argv
        case apk
            logger 4 "No Such function in alpine apk"
        case dnf
            sudo $package_manager clean all $argv
        case xbps
            sudo $package_manager-remove -O $argv
        case '*'
            logger 4 "No support package manager detected"
    end
end
