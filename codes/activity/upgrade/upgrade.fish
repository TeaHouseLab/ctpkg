function upgrade
  detectos
  switch $package_manager
  case apt aptitude
    sudo $package_manager update
    sudo $package_manager upgrade $argv
  case pacman
    sudo $package_manager -Syu $argv
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
