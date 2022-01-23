function depcheck
    set -lx deps_ok 1
    for deps in $argv
        if command -q -v $deps
        else
            set deps_ok 0
            if test -z "$dep_lost"
                set deps_lost "$deps $deps_lost"
            else
                set deps_lost "$deps"
            end
        end
    end
    if test "$deps_ok" -eq 0
        logger 4 "Please install "$deps_lost"to run this programm"
        exit
    end
end
