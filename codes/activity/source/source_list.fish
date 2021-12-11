function source_list
  detectos
  switch $package_manager
  case apt aptitude
    cat /etc/apt/sources.list  | grep --color=never "deb"
    cat /etc/apt/sources.list.d/*  | grep --color=never "deb"
  case pacman
    cat /etc/pacman.d/mirrorlist | grep --color=never "Server ="
    cat /etc/pacman.conf | grep --color=never "Server ="
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
