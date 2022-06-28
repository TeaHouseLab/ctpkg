function aur-install
    set recudir (pwd)
    dir_exist ~/.ctpm/aur
    cd ~/.ctpm/aur
    function aur-get-pkgbuild
        logger 0 "Getting $argv PKGBUILD file"
        if test (curl --progress-bar -sL "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=$argv" | head -n1) != "<!DOCTYPE html>"
            logger 1 "Check passed,getting build files"
        else
            logger 5 "Unable to get the PKGBUILD file of "$argv", please check your package name and network connection, abort"
            exit
        end
        if git clone "https://aur.archlinux.org/$argv"
            logger 1 "Build files downloaded,please review it,then press ctrl+x to continue"
            sleep 1
        else
            logger 5 "Unable to get build files of "$argv", please check your package name and network connection, abort"
            exit
        end
    end
    for target in $argv
        if test -e ~/.ctpm/aur/$target/PKGBUILD
            logger 3 'Detected an existed BUILDPKG file, would you want to remove it and build it from aur?[y/N]'
            read -n1 -P "$prefix >>> " _delete_var_
            switch $_delete_var_
                case Y y
                    rm -rf $target
                    aur-get-pkgbuild "$target"
                case N n '*'
            end
        else
            aur-get-pkgbuild "$target"
        end
        cd $target
        command nano PKGBUILD
        if test "$aur_build_only" = true
            if makepkg -s
                logger 2 "Store at ~/.ctpm/aur/$target/"
            else
                logger 5 "Package $target failed to build"
            end
        else
            makepkg -si
        end
        cd ..
    end
    cd $recudir
end
