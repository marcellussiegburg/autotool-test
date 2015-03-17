# autotool-test
Testet das Autotool

## Starten von Tests

cd autotool-cgi

oder

cd autotool-yesod

dann:

parallel (mehrfach ausführen):

RAILS_ENV=test xvfb-run -a parallel_test -e "rake test"

oder sequentiell:

xvfb-run -a rake test