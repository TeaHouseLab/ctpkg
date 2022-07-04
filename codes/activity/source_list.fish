function source_list
    switch $package_manager
        case apt aptitude
            cat /etc/apt/sources.list | grep --color=never deb
            cat /etc/apt/sources.list.d/* | grep --color=never deb
        case pacman
            cat /etc/pacman.d/mirrorlist | grep --color=never "Server ="
            cat /etc/pacman.conf | grep --color=never "Server ="
        case apk
            cat /etc/apk/repositories $argv
        case dnf yum
            $package_manager repolist $argv
        case xbps
            $package_manager-query -L $argv
        case opkg
            cat /etc/opkg/distfeeds.conf | sed -e '/^\s*#/d'
            cat /etc/opkg/customfeeds.conf | sed -e '/^\s*#/d'
        case '*'
            logger 5 "No support package manager detected"
    end
end
