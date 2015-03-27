# autotool-test
Zum Ausführen von Tests auf Instanzen des CGI-basierten Autotools und des Autotools mit Yesod.

## Anwendungsfalltests

### Installieren von benötigten Paketen

Zunächst werden Java (JRE) und Ruby, sowie ein Browser benötigt. Ggf. Xvfb, um die Tests auf Maschinen ohne Display durchzuführen. Je nach Distribution können die Installationsbefehle unterschiedlich aussehen. Zum Beispiel für Ubuntu:
```bash
sudo apt-get install openjdk-7-jre-headless ruby xvfb firefox
```
Die neueste Version des Selenium-Servers herunterladen (siehe http://docs.seleniumhq.org/download/). Zum Beispiel diese:
```bash
wget http://selenium-release.storage.googleapis.com/2.45/selenium-server-standalone-2.45.0.jar
```
Installieren benötigter ruby-Pakete
```bash
gem install selenium-webdriver
gem install parallel_tests
gem install rake
gem install minitest
gem install mysql
```

### Vorbereitung der Tests
Starten des Selenium hubs:
```
java -jar selenium-server-standalone-2.45.0.jar -role hub
```
Starten von Selenium nodes (ggf. mehrfach, je nach Bedarf; dazu unterschiedliche Port-Nummern wählen oder auf anderem Server starten)
```
xvfb-run -a java -jar selenium-server-standalone-2.45.0.jar -role node -hub http://your.dns-name.here:4444/grid/register -browserSessionReuse -port 5555
```
Testfälle herunterladen und zum Verzeichnis der Anwendungsfalltests wechseln
```bash
git clone https://github.com/marcellussiegburg/autotool-test
cd use-case
```
dann die Konfiguration nach der jeweils ausgeführten Instanz durchführen (```config.yml```)

### Starten von Tests

Wahl der Autotool implementation entweder (CGI-basiertes Autotool)
```bash
cd autotool-cgi
```
oder (Autotool mit Yesod)
```bash
cd autotool-yesod
```
Tests ausführen
sequentiell
```bash
rake test
```
parallel mit Verteilung auf die Anzahl der Prezessorkerne
```bash
parallel_test *Test.rb
```
parallel (mehrfach ausführen):
```bash
parallel_test -e "rake test"
```

## Belastungstests

### Installieren von benötigten Paketen

Zunächst wird cURL und Bash (ab Version 4) benötigt. Ggf. R, um die Auswertung durchzuführen. Je nach Distribution können die Installationsbefehle unterschiedlich aussehen. Zum Beispiel für Ubuntu:
```bash
apt-get install curl r-base-core
```

### Vorbereitung der Tests

Testfälle herunterladen und zum Verzeichnis der Belastungstests wechseln.
```bash
git clone https://github.com/marcellussiegburg/autotool-test
cd belastung
```
Erstellen von Datensätzen in der Datenbank, so dass eine Einsendung existiert.
Konfiguration der Parameter in den ersten Zeilen der Datei ```test.sh``` Anpassung der Parameter für die `GET`-Befehle (je nach Stand der Datenbank). Bei CGI-basiertem Autotool durch Navigation zu der Seite des Bearbeiten der Einsendung und einfügen der Formulardaten (siehe HTML-Quelltext) in die Anfrage. Bei yesod durch Navigation zur Seite des Bearbeitden der Einsendung und kopieren der URL.

### Starten von Tests

```bash
bash test.sh
```

ggf. Auswertung durch
```bash
bash auswertung.sh
```
