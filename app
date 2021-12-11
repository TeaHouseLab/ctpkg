#!/usr/bin/env fish
function help_echo
  set_color cyan
  set_color normal
  echo "==========Help Documentation=========="
  set_color green
  echo "argv[1] argv[2+]"
  set_color normal
  echo " -argv[1]:the command to execute"
  echo "  -Available:c(clean cache)
             i(install)
             p(purge)
             s(search)
             l(list installed package)
             si(show info of a package)
             sc(source used)
             upd(update datebase)
             upg(upgrade)"
  echo " -argv[2+]:the package you want to change"
  echo "--------------------------------------"
  set_color green
  echo "ctpm argv[2+]"
  set_color normal
  echo " -argv[1]:the command to execute"
  echo "  -Available:c(clean cache)
             i(install)
             p(purge)
             l(list installed package)"
  echo " -argv[2+]:the package you want to change"
  echo "========================================"
end
function clean
  detectos
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
function search
  detectos
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
function list
  detectos
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
function update
  detectos
  switch $package_manager
  case apt aptitude
    sudo $package_manager update
  case pacman
    sudo $package_manager -Sy
  case '*'
    set_color red
    echo "$prefix No support package manager detected"
    set_color normal
  end
end
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
echo Build_Time_UTC=2021-12-11_09:38:56
set prefix [ctpkg]
set_color cyan
echo "$prefix CenterLinux Package Manager Version FrostFlower@build0 | TeaHouseLab at ruzhtw.top"
set_color normal
switch $argv[1]
case c
  clean
case i
  install $argv[2..-1]
case p
  purge $argv[2..-1]
case s
  search $argv[2..-1]
case l
  list
case si
  show $argv[2..-1]
case sc
  source_list
case upd
  update
case upg
  upgrade $argv[2..-1]
case ctpm
  ctpm $argv[2] $argv[3..-1]
case v version
  set_color yellow
  echo "FrostFlower@build0"
  set_color normal
case h help '*'
  help_echo
end
set -e package_manager
set_color cyan
echo "$prefix Done"
set_color normal
