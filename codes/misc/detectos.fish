function detectos
    #debian
    if test -e /etc/debian_version
        if command -q aptitude
            set -g package_manager aptitude
        else
            set -g package_manager apt
        end
    end
    #archlinux
    if test -e /etc/arch-release
        if command -q pacman
            set -g package_manager pacman
        end
    end
    #alpine
    if test -e /etc/alpine-release
        if command -q apk
            set -g package_manager apk
        end
    end
    #fedora
    if test -e /etc/fedora-release
        set -g package_manager dnf
    end
    #centos
    if test -e /etc/centos-release
        set -g package_manager yum
    end
    #voidlinux
    if command -q xbps-install
        set -g package_manager xbps
    end
end
