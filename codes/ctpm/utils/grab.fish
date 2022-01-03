function grab
    switch $argv[1]
        case l
            curl -s -L $ctpm_source/list
        case s
            for ctpm_package in $argv[2..-1]
                printf "found in source:"
                curl -s -L $ctpm_source/list | grep $ctpm_package
            end
        case *
            for ctpm_package in $argv
                if curl -s -L -o /tmp/$ctpm_package.ctpkg $ctpm_source/$ctpm_package.ctpkg
                    if file /tmp/$ctpm_package.ctpkg | grep -q 'tar archive'
                    else
                        logger 4 "The package seems not a ctpkg file,remove and abort"
                        rm /tmp/$ctpm_package.ctpkg
                        exit
                    end
                    logger 1 "package:$ctpm_package downloaded,installing..."
                    cd /tmp
                    extract $ctpm_package
                    rm $ctpm_package
                else
                    logger 4 "package:$ctpm_package failed to download,ignored"
                end
            end
    end
end
