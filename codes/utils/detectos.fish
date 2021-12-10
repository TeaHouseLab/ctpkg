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
  set_color cyan
  echo "$prefix Set backend as $package_manager"
  set_color normal
end
