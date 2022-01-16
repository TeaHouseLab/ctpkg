set -lx prefix [ctpkg]
ctconfig_init
set -lx ctpm_source (sed -n '/source=/'p /etc/centerlinux/conf.d/ctpm.conf | sed 's/source=//g')
if [ "$ctpm_source" = "" ]
else
    set ctpm_source https://cdngit.ruzhtw.top/ctpm/
end
set_color cyan
echo "$prefix CenterLinux Package Manager Version pomelo@build5 | TeaHouseLab at ruzhtw.top"
set_color normal
switch $argv[1]
    case c
        clean $argv[2..-1]
    case grab
        logger 0 "Using ctpm source:$ctpm_source"
        grab $argv[2..-1]
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
        end
    case install
        install_script ctpkg
    case uninstall
        uninstall_script ctpkg
    case v version
        set_color yellow
        echo "pomelo@build5"
        set_color normal
    case h help '*'
        help_echo
end
set -e package_manager
set_color cyan
echo "$prefix Done"
set_color normal
