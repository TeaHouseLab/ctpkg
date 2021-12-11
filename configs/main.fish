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
  upgrade
case ctpm
  ctpm $argv[2] $argv[3..-1]
case v version
  set_color yellow
  echo "FrostFlower@build0"
  set_color normal
case h help '*'
  help_echo
end
set_color cyan
echo "$prefix Done"
set_color normal
