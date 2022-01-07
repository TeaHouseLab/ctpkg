function grab
    logger 0 "Using ctpm source:$ctpm_source"
    switch $argv[1]
        case l
            echo "found in source:"
            curl -s -L $ctpm_source/list
        case s
            for ctpm_package in $argv[2..-1]
                echo "found in source:"
                curl -s -L $ctpm_source/list | grep $ctpm_package
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
