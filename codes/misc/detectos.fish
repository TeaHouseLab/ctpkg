function detectos
  #debian
  if test -e /etc/debian_version
    if test -e /usr/bin/aptitude
      set -g package_manager aptitude
    else
      set -g package_manager apt
    end
  end
  #archlinux
  if test -e /usr/bin/pacman;and test -e /etc/pacman.d
    set -g package_manager pacman
  end
  #alpine
  if test -e /usr/bin/apk;and test -e /etc/apk
    set -g package_manager apk
  end
  #fedora
  if test -e /etc/fedora-release
    set -g package_manager dnf
  end
  #voidlinux
  if cat /etc/os-release | grep -q 'void'
    set -g package_manager xbps
  end
end
