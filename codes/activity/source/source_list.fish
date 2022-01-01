function source_list
    detectos
    switch $package_manager
        case apt aptitude
            cat /etc/apt/sources.list | grep --color=never deb
            cat /etc/apt/sources.list.d/* | grep --color=never deb
        case pacman
            cat /etc/pacman.d/mirrorlist | grep --color=never "Server ="
            cat /etc/pacman.conf | grep --color=never "Server ="
        case apk
            cat /etc/apk/repositories
        case dnf
            $package_manager repolist
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end
