function show
  detectos
  switch $package_manager
  case apt aptitude
    $package_manager show $argv
  case pacman
    $package_manager -Si $argv
  case '*'
    set_color red
    echo "[rupm]No support package manager detected"
    set_color normal
  end
end
