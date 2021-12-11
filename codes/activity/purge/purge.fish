function purge
  detectos
  switch $package_manager
  case apt
    sudo $package_manager purge $argv
    sudo $package_manager autoremove --purge
  case aptitude
    sudo $package_manager purge $argv
  case pacman
    sudo $package_manager -Rn $argv
    sudo $package_manager -Rn (pacman -Qtdq)
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
