function clean
  detect-backend
  switch $package_manager
  case apt aptitude
    sudo $package_manager clean
  case pacman
    sudo $package_manager -Scc
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
