function upgrade
  detect-backend
  switch $package_manager
  case apt aptitude
    sudo $package_manager update
    sudo $package_manager upgrade
  case pacman
    sudo $package_manager -Syu
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
