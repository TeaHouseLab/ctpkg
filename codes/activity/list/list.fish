function list
  detect-backend
  switch $package_manager
  case apt aptitude
    apt list --installed
  case pacman
    $package_manager -Qq
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
