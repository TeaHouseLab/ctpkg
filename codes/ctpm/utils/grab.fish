function grab
    for ctpm_package in $argv
        curl -s -L -o /tmp/$ctpm_package https://cdngit.ruzhtw.top/ctpm/$ctpm_package
        cd /tmp
        ctpm i $ctpm_package
        rm $ctpm_package
    end
end
