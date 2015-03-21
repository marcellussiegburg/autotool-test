#!/bin/bash

AUTOTOOL_CGI_GET="curl -X POST --form F3=C2 --form F6=C4 --form F11=C9 --form F14=C12 --form F17=C15 --form F23=C18 --form F25=C24 --form F28=C26 --form F33=C29 --form F39=C38 --form F43=C40 --form F56=C52 http://fsrb6.imn.htwk-leipzig.de/cgi-bin/Super.cgi?school=school"
AUTOTOOL_CGI_POST="curl -X POST --form F3=C2 --form F6=C5 --form 'F7=Hans%20Mueller' --form 'F8=egal' --form 'F9=egal' --form 'F10=egal' --form 'C11=submit' http://fsrb6.imn.htwk-leipzig.de/cgi-bin/Super.cgi?school=school"
AUTOTOOL_YESOD_GET="curl -X GET http://fsrb6.imn.htwk-leipzig.de:3003/einsendung/2080/1"
AUTOTOOL_YESOD_POST="curl -X POST --form 'matriculationnumber=Hans%20Mueller' --form 'firstname=egal' --form 'surname=egal' --form 'email=egal' http://fsrb6.imn.htwk-leipzig.de:3003/auth/page/autotool/create"

declare -A COMMANDS=( ["AUTOTOOL_CGI_POST"]=$AUTOTOOL_CGI_GET ["AUTOTOOL_YESOD_POST"]=$AUTOTOOL_YESOD_POST ["AUTOTOOL_CGI_GET"]=$AUTOTOOL_CGI_GET ["AUTOTOOL_YESOD_GET"]=$AUTOTOOL_YESOD_GET ["AUTOTOOL_CGI_MIXED"]="$AUTOTOOL_CGI_GET; $AUTOTOOL_CGI_POST" ["AUTOTOOL_YESOD_MIXED"]="$AUTOTOOL_YESOD_GET; $AUTOTOOL_YESOD_POST" )

declare -A LOG_FILE_NAMES=( ["AUTOTOOL_CGI_POST"]="test_cgi_post.txt" ["AUTOTOOL_YESOD_POST"]="test_yesod_post.txt" ["AUTOTOOL_CGI_GET"]="test_cgi_get.txt" ["AUTOTOOL_YESOD_GET"]="test_yesod_get.txt" ["AUTOTOOL_CGI_MIXED"]="test_cgi_mixed.txt" ["AUTOTOOL_YESOD_MIXED"]="test_yesod_mixed.txt" )

for TEST_CASE in "${!COMMANDS[@]}"
do
    echo $TEST_CASE
    for i in {1..100}
    do
        #echo $(echo "${COMMANDS["$TEST_CASE"]}")
        (time ./run.sh 100 bash -c "${COMMANDS["$TEST_CASE"]}" &>/dev/null) 2>> "${LOG_FILE_NAMES["$TEST_CASE"]}" &
    done
    sleep 120
done

#TODO Sequentiell und Parallel
