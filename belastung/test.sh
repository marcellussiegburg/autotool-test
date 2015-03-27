#!/bin/bash

PARALLEL=true
SEQUENCE=1
RUNS=1000
USER=???
PASSWORD=???
AUTOTOOL_CGI="http://???/cgi-bin/Super.cgi?school=school"
AUTOTOOL_YESOD="http://???:???"

AUTOTOOL_CGI_GET="curl -X POST --form F3=C2 --form F6=C4 --form F7=$USER --form F8=$PASSWORD --form F11=C9 --form F14=C12 --form F17=C15 --form F23=C18 --form F25=C24 --form F28=C26 --form F33=C29 --form F39=C38 --form F43=C40 --form C52=C52 $AUTOTOOL_CGI"
AUTOTOOL_CGI_POST="curl -X POST --form F3=C2 --form F6=C5 --form F7=Hans%20Mueller --form F8=egal --form F9=egal --form F10=egal --form C11=submit $AUTOTOOL_CGI"
AUTOTOOL_YESOD_GET="curl -b keks -X GET $AUTOTOOL_YESOD/einsendung/???/???"
AUTOTOOL_YESOD_POST="curl -X POST --form matriculationnumber=Hans%20Mueller --form firstname=egal --form surname=egal --form email=egal $AUTOTOOL_YESOD/auth/page/autotool/create"

declare -A COMMANDS=( ["AUTOTOOL_CGI_POST"]=$AUTOTOOL_CGI_GET ["AUTOTOOL_YESOD_POST"]=$AUTOTOOL_YESOD_POST ["AUTOTOOL_CGI_GET"]=$AUTOTOOL_CGI_GET ["AUTOTOOL_YESOD_GET"]=$AUTOTOOL_YESOD_GET ["AUTOTOOL_CGI_MIXED"]="$AUTOTOOL_CGI_GET; $AUTOTOOL_CGI_POST" ["AUTOTOOL_YESOD_MIXED"]="$AUTOTOOL_YESOD_GET; $AUTOTOOL_YESOD_POST" )

declare -A LOG_FILE_NAMES=( ["AUTOTOOL_CGI_POST"]="cgi_post.txt" ["AUTOTOOL_YESOD_POST"]="yesod_post.txt" ["AUTOTOOL_CGI_GET"]="cgi_get.txt" ["AUTOTOOL_YESOD_GET"]="yesod_get.txt" ["AUTOTOOL_CGI_MIXED"]="cgi_mixed.txt" ["AUTOTOOL_YESOD_MIXED"]="yesod_mixed.txt" )

curl -X POST -c keks --form school=??? --form matriculationnumber=$USER --form password=$PASSWORD "$AUTOTOOL_YESOD/auth/page/autotool/login"

for TEST_CASE in "${!COMMANDS[@]}"
do
    if $PARALLEL
    then
        echo "$TEST_CASE (parallel)"
    else
        echo "$TEST_CASE (sequential)"
    fi
    for i in $(seq $RUNS)
    do
        if $PARALLEL
        then
            (time ./run.sh $SEQUENCE bash -c "${COMMANDS["$TEST_CASE"]}" &>/dev/null) 2>> test_parallel_"$RUNS"_"$SEQUENCE"_"${LOG_FILE_NAMES["$TEST_CASE"]}" &
        else
            (time ./run.sh $SEQUENCE bash -c "${COMMANDS["$TEST_CASE"]}" &>/dev/null) 2>> test_sequential_"$RUNS"_"$SEQUENCE"_"${LOG_FILE_NAMES["$TEST_CASE"]}"
        fi
    done
    wait
done

rm keks
