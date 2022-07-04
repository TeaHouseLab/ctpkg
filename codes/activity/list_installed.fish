function list_installed
    switch $package_manager
        case apt aptitude
            apt list --installed $argv
        case pacman
            $package_manager -Q $argv
        case apk
            $package_manager list -I $argv
        case yum dnf
            rpm -qa
        case xbps
            $package_manager-query -l $argv
        case opkg
            $package_manager list-installed $argv
        case '*'
            logger 5 "No support package manager detected"
    end
end
