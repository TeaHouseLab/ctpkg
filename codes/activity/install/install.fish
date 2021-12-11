function install
  detectos
  switch $package_manager
  case apt aptitude
    sudo $package_manager install $argv
  case pacman
    sudo $package_manager -S $argv
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
