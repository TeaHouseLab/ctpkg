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
  echo " -argv[2+]:the package you want to do on"
  echo "--------------------------------------"
  set_color green
  echo "ctpm argv[2+]"
  set_color normal
  echo " -argv[1]:the command to execute"
  echo "  -Available:
             i(install)
             p(purge)
             l(list installed package)"
  echo " -argv[2+]:the package you want to change"
  echo "========================================"
end

function logger-warn
  set_color magenta
  echo "$prefix [Warn] $argv[1..-1]"
  set_color normal
end
function logger-error
  set_color red
  echo "$prefix [Error] $argv[1..-1]"
  set_color normal
end
function logger-info
  set_color normal
  echo "$prefix [Info] $argv[1..-1]"
  set_color normal
end
function logger-debug
  set_color yellow
  echo "$prefix [Debug] $argv[1..-1]"
  set_color normal
end
function logger-success
  set_color green
  echo "$prefix [Successed] $argv[1..-1]"
  set_color normal
end
function logger -d "a lib to print msg quickly"
switch $argv[1]
case 0
  logger-info $argv[2..-1]
case 1
  logger-success $argv[2..-1]
case 2
  logger-debug $argv[2..-1]
case 3
  logger-warn $argv[2..-1]
case 4
  logger-error $argv[2..-1]
end
end

function checkdependence
  if test -e $argv
    echo -e "\033[32m[checkdependence]check passed - $argv exist\033[0m"
  else
    echo -e "\033[0;31m[checkdependence]check failed - plz install $argv\033[0m"
    exit
  end
end
function checknetwork
  if curl -s -L $argv[1] | grep -q $argv[2]
    echo -e "\033[32m[checknetwork]check passed - u`ve connected to $argv[1]\033[0m"
  else
    echo -e "\033[0;31m[checknetwork]check failed - check your network connection\033[0m"
  end
end
function dir_exist
  if test -d $argv[1]
    echo -e "\033[32m[checkdir]check passed - dir $argv[1] exist\033[0m"
  else
    echo -e "\033[0;31m[checkdir]check failed - dir $argv[1] doesn't exist,going to makr one\033[0m"
    mkdir $argv[1]
  end
end
function list_menu
ls $argv | sed '\~//~d'
end

function install_script
set installname $argv[1]
  set dir (realpath (dirname (status -f)))
  set filename (status --current-filename)
  chmod +x $dir/$filename
  sudo cp $dir/$filename /usr/bin/$installname
  set_color green
  echo "$prefix Installed"
  set_color normal
end
function uninstall_script
set installname $argv[1]
  sudo rm /usr/bin/$installname
  set_color green
  echo "$prefix Removed"
  set_color normal
end

function clean
    detectos
    switch $package_manager
        case apt aptitude 
            sudo $package_manager clean $argv
        case pacman
            sudo $package_manager -Scc $argv
        case apk
            logger 4 "$prefix No Such function in alpine apk"
        case dnf
            sudo $package_manager clean all $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end

function install
    detectos
    switch $package_manager
        case apt aptitude
            sudo $package_manager install $argv
        case pacman
            sudo $package_manager -S $argv
        case apk
            sudo $package_manager add $argv
        case dnf
            sudo $package_manager install $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end

function search
    detectos
    switch $package_manager
        case apt aptitude apk dnf
            $package_manager search $argv
        case pacman
            $package_manager -Ss $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end

function upgrade
    detectos
    switch $package_manager
        case apt aptitude
            sudo $package_manager update $argv
            sudo $package_manager upgrade $argv
        case pacman
            sudo $package_manager -Syu $argv
        case apk
            sudo $package_manager update $argv
            sudo $package_manager upgrade $argv
        case dnf
            sudo $package_manager update $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
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
        case apk
            sudo $package_manager del $argv
        case dnf
            sudo $package_manager remove $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end

function list
    detectos
    switch $package_manager
        case apt aptitude
            apt list --installed $argv
        case pacman
            $package_manager -Qq $argv
        case apk
            $package_manager list $argv
        case dnf
            $package_manager list installed $argv
        case '*'
          logger 4 "$prefix No support package manager detected"
    end
end

function update
    detectos
    switch $package_manager
        case apt aptitude
            sudo $package_manager update $argv
        case pacman
            sudo $package_manager -Sy $argv
        case apk
            sudo $package_manager update $argv
        case dnf
            sudo $package_manager check-update $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end

function source_list
    detectos
    switch $package_manager
        case apt aptitude
            cat /etc/apt/sources.list | grep --color=never deb
            cat /etc/apt/sources.list.d/* | grep --color=never deb
        case pacman
            cat /etc/pacman.d/mirrorlist | grep --color=never "Server ="
            cat /etc/pacman.conf | grep --color=never "Server ="
        case apk
            cat /etc/apk/repositories
        case dnf
            $package_manager repolist
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end

function show
    detectos
    switch $package_manager
        case apt aptitude
            $package_manager show $argv
        case pacman
            $package_manager -Si $argv
        case apk dnf
            $package_manager info $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
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
  #alpine
  if cat /etc/os-release | grep -q 'Alpine Linux'
    set -g package_manager apk
  end
  #fedora
  if test -e /etc/fedora-release
    set -g package_manager dnf
  end
  logger 0 "Set backend as $package_manager"
end

function user_list
    if ls -1qA ~/.ctpm/package_info/ | grep -q .
        echo ">Installed-UserLevel<"
        cd ~/.ctpm/package_info/
        list_menu *.info | sed 's/.info//g'
    else
        echo ">Installed-UserLevel<"
    end
end

function user_install
    logger 0 "installing $package_name as user level"
    cat src/file_list | tee ~/.ctpm/package_info/$package_name >/dev/null
    echo package_name=$package_name | sudo tee ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_ver=$package_ver | sudo tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_level=$package_level | sudo tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    for src_file in (cat src/file_list)
        sudo mv -f src$src_file ~/$src_file
    end
end

function user_purge
    for package_ctpm in $argv
        if test -e ~/.ctpm/package_info/$package_ctpm
            for src_file in (cat ~/.ctpm/package_info/$package_ctpm)
                sudo rm -rf ~/$src_file
            end
            sudo rm ~/.ctpm/package_info/$package_ctpm
            sudo rm ~/.ctpm/package_info/$package_ctpm.info
            logger 1 purged package:$package_ctpm
        else
            logger 4 "no info file of package:$package_ctpm,abort"
        end
    end
end

function ctpm_show
    for package_ctpm in $argv[1..-1]
        if test -e /var/lib/ctpm/package_info/$package_ctpm.info
            set package_level (sed -n '/package_level=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_level=//g')
            set package_name (sed -n '/package_name=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_name=//g')
            set package_ver (sed -n '/package_ver=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_ver=//g')
            echo "-----------"
            echo "package_name: $package_name"
            echo "package_ver: $package_ver"
            echo "package_level: $package_level"
            echo "-----------"
        end
        if test -e ~/.ctpm/package_info/$package_ctpm.info
            set package_level (sed -n '/package_level=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_level=//g')
            set package_name (sed -n '/package_name=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_name=//g')
            set package_ver (sed -n '/package_ver=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_ver=//g')
            echo "-----------"
            echo "package_name: $package_name"
            echo "package_ver: $package_ver"
            echo "package_level: $package_level"
            echo "-----------"
        end
    end
end

function extract
    set -lx package_ctpm
    check_environment
    if test -d /tmp/ctpm
    else
        mkdir /tmp/ctpm
    end
    if [ -w /tmp/ctpm ]
    else
        logger 4 '/tmp/ctpm is not accessable to this user,abort'
    end
    for package_ctpm in $argv
        if test -e $package_ctpm.ctpkg
        else
            logger 4 "$package_ctpm.ctpkg not found,abort"
            exit
        end
        cp $package_ctpm.ctpkg /tmp/ctpm
        cd /tmp/ctpm
        logger 0 'Extracting the package'
        tar xf $package_ctpm.ctpkg
        set -lx package_level (sed -n '/package_level=/'p ctpm_pkg_info | sed 's/package_level=//g')
        set -lx package_name (sed -n '/package_name=/'p ctpm_pkg_info | sed 's/package_name=//g')
        set -lx package_ver (sed -n '/package_ver=/'p ctpm_pkg_info | sed 's/package_ver=//g')
        switch $package_level
            case user
                user_install
            case sys
                sys_install
        end
        cd ..
        rm -rf ctpm
        logger 0 Processed
    end
end

function sys_install
    logger 0 "installing $package_name ver:$package_ver as sys level"
    cat src/file_list | sudo tee /var/lib/ctpm/package_info/$package_name >/dev/null
    echo package_name=$package_name | sudo tee /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_ver=$package_ver | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_level=$package_level | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    for src_file in (cat src/file_list)
        sudo mv -f src$src_file $src_file
    end
end

function sys_list
    if ls -1qA /var/lib/ctpm/package_info/ | grep -q .
        echo ">Installed-SysLevel<"
        cd /var/lib/ctpm/package_info/
        list_menu *.info | sed 's/.info//g'
    else
        echo ">Installed-SysLevel<"
    end
end

function sys_purge
    for package_ctpm in $argv
        if test -e /var/lib/ctpm/package_info/$package_ctpm
            for src_file in (cat /var/lib/ctpm/package_info/$package_ctpm)
                sudo rm -rf $src_file
            end
            sudo rm /var/lib/ctpm/package_info/$package_ctpm
            sudo rm /var/lib/ctpm/package_info/$package_ctpm.info
            logger 1 purged package:$package_ctpm
        else
            logger 4 "no info file of package:$package_ctpm,abort"
        end
    end
end

function ctconfig_init
    if test -d /etc/centerlinux/conf.d/
    else
        set_color red
        echo "$prefix Detected First Launching,We need your password to create the config file"
        set_color normal
        sudo mkdir -p /etc/centerlinux/conf.d/
    end
    sudo sh -c "echo "source=https://cdngit.ruzhtw.top/ctpm/" > /etc/centerlinux/conf.d/ctpm.conf"
end

function check_environment
    if test -d /var/lib/ctpm/package_info
    else
        sudo mkdir -p /var/lib/ctpm/package_info
    end
    if test -d ~/.ctpm/package_info
    else
        mkdir -p ~/.ctpm/package_info
    end
end

function pack
    set package_level (sed -n '/package_level=/'p ctpm_pkg_info | sed 's/package_level=//g')
    set package_name (sed -n '/package_name=/'p ctpm_pkg_info | sed 's/package_name=//g')
    set package_ver (sed -n '/package_ver=/'p ctpm_pkg_info | sed 's/package_ver=//g')
    if [ "$package_name" = "" ]
        logger 4 'No package_name defined,abort'
        exit
    end
    if [ "$package_ver" = "" ]
        logger 4 'No package_ver defined,abort'
        exit
    end
    if [ "$package_level" = "" ]
        logger 4 'No package_level defined,abort'
        exit
    end
    if test -d src
        if test -e src/file_list
        else
            logger 4 'No src/file_list defined,abort'
        end
    else
        logger 4 'No src directory,abort'
    end
    tar zcf $package_name.ctpkg .
    logger 0 "Processed,store at $package_name.ctpkg"
end

function grab
    for ctpm_package in $argv
        curl -s -L -o /tmp/$ctpm_package https://cdngit.ruzhtw.top/ctpm/$ctpm_package.ctpkg
        cd /tmp
        ctpm i $ctpm_package
        rm $ctpm_package
    end
end

echo Build_Time_UTC=2022-01-02_05:29:59
set -lx prefix [ctpkg]
set ctpm_source (sed -n '/source=/'p /etc/centerlinux/conf.d/ctpm.conf | sed 's/source=//g')
if [ "$ctpm_source" = "" ]
else
set -lx ctpm_source https://cdngit.ruzhtw.top/ctpm/
end
set_color cyan
echo "$prefix CenterLinux Package Manager Version FrostFlower@build31 | TeaHouseLab at ruzhtw.top"
set_color normal
switch $argv[1]
    case c
        clean $argv[2..-1]
    case i
        install $argv[2..-1]
    case p
        purge $argv[2..-1]
    case s
        search $argv[2..-1]
    case l
        list $argv[2..-1]
    case si
        show $argv[2..-1]
    case sc
        source_list $argv[2..-1]
    case upd
        update $argv[2..-1]
    case upg
        upgrade $argv[2..-1]
    case ctpm
        switch $argv[2]
            case i
                extract $argv[3..-1]
            case l
                switch $argv[3]
                    case sys
                        sys_list
                    case user
                        user_list
                    case '*'
                        sys_list
                        user_list
                end
            case p
                switch $argv[3]
                    case sys
                        sys_purge $argv[4..-1]
                    case user
                        user_purge $argv[4..-1]
                end
            case ss
                ctpm_show $argv[3..-1]
            case pack
                pack
            case grub
                grub $argv[3..-1]
        end
    case install
        install_script ctpkg
    case uninstall
        uninstall_script ctpkg
    case v version
        set_color yellow
        echo "FrostFlower@build31"
        set_color normal
    case h help '*'
        help_echo
end
set -e package_manager
set_color cyan
echo "$prefix Done"
set_color normal
