function grab
    logger 0 "Using ctpm source:$ctpm_source"
    switch $argv[1]
        case upd
            if sudo curl -s -L -o /var/lib/ctpm/world $ctpm_source/list
                logger 1 "Package List downloaded"
            else
                logger 4 "Failed to download package list from online repo,abort"
                exit
            end
        case l
            echo "found in source:"
            cat /var/lib/ctpm/world
        case s
            echo "found in source:"
            for ctpm_package in $argv[2..-1]
                grep $ctpm_package /var/lib/ctpm/world
            end
        case '*'
            for ctpm_package in $argv
                logger 0 "Grabbing $ctpm_package"
                if curl -s -L -o /tmp/$ctpm_package.ctpkg $ctpm_source/$ctpm_package.ctpkg
                    if file /tmp/$ctpm_package.ctpkg | grep -q 'gzip compressed'
                    else
                        logger 4 "The package seems not a ctpkg file,remove and abort,please try to download again"
                        rm /tmp/$ctpm_package.ctpkg
                        exit
                    end
                    logger 1 "package:$ctpm_package downloaded,installing..."
                    cd /tmp
                    extract $ctpm_package.ctpkg
                    rm $ctpm_package.ctpkg
                else
                    logger 4 "package:$ctpm_package failed to download,ignored"
                end
            end
    end
end
