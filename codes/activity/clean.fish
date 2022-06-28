function clean
    switch $package_manager
        case apt aptitude
            sudo $package_manager clean $argv
        case pacman
            sudo $package_manager -Scc $argv
        case apk
            logger 5 "No Such function in alpine apk"
        case dnf yum
            sudo $package_manager clean $argv
        case xbps
            sudo $package_manager-remove -O $argv
        case '*'
            logger 5 "No support package manager detected"
    end
end
