function grab
    for ctpm_package in $argv
        curl -s -L -o /tmp/$ctpm_package $ctpm_source/$ctpm_package.ctpkg
        cd /tmp
        extract $ctpm_package
        rm $ctpm_package
    end
end
