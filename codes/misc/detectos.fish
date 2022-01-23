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
  if test -e /etc/arch-release
    set -g package_manager pacman
  end
  #alpine
  if cat /etc/os-release | grep -q 'Alpine Linux'
    set -g package_manager apk
  end
  #fedora
  if test -e /etc/fedora-release
    set -g package_manager dnf
  end
  logger 0 "Set backend as $package_manager"
end
