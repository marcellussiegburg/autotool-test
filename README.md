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

## install ChromeDriver

wget http://chromedriver.storage.googleapis.com/2.14/chromedriver_linux64.zip

unzip chromedriver_linux64.zip

mv chromedriver /usr/local/bin
