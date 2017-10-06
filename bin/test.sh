#!/bin/bash

BUILD_STATE=0
function print_title {
    echo --------------------------------------------------------------------------------
    echo
    echo $1
    echo
}
function check_state {
    time $@
    BUILD_STATE=$((BUILD_STATE+$?))
}
function print_formatted {
    if test -t 1; then

        # see if it supports colors...
        ncolors=$(tput colors)

        if test -n "$ncolors" && test $ncolors -ge 8; then
            bold="$(tput bold)"
            underline="$(tput smul)"
            standout="$(tput smso)"
            normal="$(tput sgr0)"
            black="$(tput setaf 0)"
            red="$(tput setaf 1)"
            green="$(tput setaf 2)"
            yellow="$(tput setaf 3)"
            blue="$(tput setaf 4)"
            magenta="$(tput setaf 5)"
            cyan="$(tput setaf 6)"
            white="$(tput setaf 7)"
        fi
    fi

    echo -e "${!2}$1${normal}"
}

rm -rf reports/*
mkdir -p reports/logs reports/coverage

# TODO Add code coverage driver

print_title "Running PHPUnit"
check_state ./vendor/bin/phpunit \
    --testsuite=unit,functional \
    #--coverage-clover reports/logs/clover.xml \
    #--coverage-crap4j reports/logs/crap4j.xml \
    --log-junit reports/logs/junit.xml
    #--coverage-html reports/coverage

print_title "Find coding standard violations"
check_state phpcs --report=full \
    --report-checkstyle=reports/logs/checkstyle.xml \
    --standard=PSR2 \
    --extensions=php \
    --ignore=autoload.php \
    src

print_title "Find duplicate code"
check_state ./vendor/bin/phpcpd --log-pmd reports/logs/pmd-cpd.xml src

# Final message
print_title "Finished all tests"
if [ "$BUILD_STATE" -eq 0 ]; then
    print_formatted "Build is STABLE" green
else
    print_formatted "Build is UNSTABLE" red
fi
exit $BUILD_STATE
