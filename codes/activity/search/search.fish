function search
  detect-backend
  switch $package_manager
  case apt aptitude
    $package_manager search $argv
  case pacman
    $package_manager -Ss $argv
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
