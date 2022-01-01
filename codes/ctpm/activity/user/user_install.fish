function user_install
    logger 0 "installing $package_name as user level"
    echo package_unis=$package_unis >~/.ctpm/package_info/$package_name
    for src_file in (ls -a src/)
        echo ~/ctpm_pkg/$package_name/$src_file >>~/.ctpm/package_info/$package_name
        if test -d "~/ctpm_pkg/$package_name"
        else
            mkdir -p ~/ctpm_pkg/$package_name
        end
        sudo mv src/$src_file ~/ctpm_pkg/$package_name
    end
end
