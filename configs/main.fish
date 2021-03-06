set -lx prefix [ctpkg]
checkdependence file curl tar rm mv sudo
ctconfig_init
set -g package_manager (sed -n '/backend=/'p /etc/centerlinux/conf.d/ctpkg.conf | sed 's/backend=//g')
if [ "$package_manager" = "" ]
    detectos
end
argparse -i -n $prefix 'b/ctbackend=' -- $argv
if set -q _flag_ctbackend
    set -g package_manager $_flag_ctbackend
end
logger 0 "Set backend as $package_manager"
switch $argv[1]
    case c
        clean $argv[2..-1]
    case grab
        logger 0 "Loading grab-ctpm(plugin)"
        grab $argv[2..-1]
    case i
        install $argv[2..-1]
    case ir
        reinstall $argv[2..-1]
    case p
        purge $argv[2..-1]
    case pg
        autoremove $argv[2..-1]
    case s
        search $argv[2..-1]
    case l
        list $argv[2..-1]
    case li
        list_installed $argv[2..-1]
    case si
        show $argv[2..-1]
    case sc
        source_list $argv[2..-1]
    case upd
        update $argv[2..-1]
    case upg
        upgrade $argv[2..-1]
    case aur
        logger 0 "Loading aur-pacman(plugin)..."
        checkdependence jq git
        switch $argv[2]
            case i
                aur-install $argv[3..-1]
            case b
                set aur_build_only true
                aur-install $argv[3..-1]
            case s
                aur-search $argv[3..-1]
            case c
                logger 3 'Please confirm that you really want to clean aur build cache[y/N]'
                read -n1 -P "$prefix >>> " _delete_var_
                switch $_delete_var_
                    case Y y
                        rm -rf ~/.ctpm/aur/*
                    case N n '*'
                        logger 1 Abort
                end
        end
    case ctpm
        logger 0 "Set backend as ctpm"
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
                    case h help '*'
                        help_echo
                end
            case si
                ctpm_show $argv[3..-1]
            case h help '*'
                help_echo
        end
    case install
        install_script ctpkg
    case uninstall
        uninstall_script ctpkg
    case v version
        logger 1 "CenterLinux Package Manager Hairpin@build6 | TeaHouseLab at ruzhtw.top"
    case h help '*'
        help_echo
end
set -e package_manager
