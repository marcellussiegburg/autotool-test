require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require 'selenium-webdriver'
require 'mysql'
require 'yaml'

class AutotoolTest < MiniTest::Test

  def setup
    @config = YAML.load_file 'config.yaml'
    @ui = YAML.load_file 'ui.yaml'
    @fehler = YAML.load_file 'fehler.yaml'
    @base_url = @config['url']
    @driver = Selenium::WebDriver.for(:firefox)
    @db = Mysql.new @config['dbServer'], @config['dbUser'], @config['dbPasswort'], @config['db']
  end

  def zufallsWort(laenge)
    chars = [('a'..'z').to_a, ('A'..'Z').to_a].flatten
    (1..laenge).map {chars[rand(chars.length)]}.join
  end

  def testWort
    "TEST" + zufallsWort(8)
  end

  def mitSchuleAccount(funktion)
    mitSchule(->(name) {
      schule = getSchule(name)
      mitAccount(schule['UNr'], ->(mnr) {
        funktion.call(schule, mnr)
      })
    })
  end

  def mitAccount(unr, funktion)
    mnr = testWort
    vorname = testWort
    name = testWort
    email = @config['email']
    angelegt = accountAnlegen(mnr, unr, vorname, name, email)
    setPassword(mnr, vorname, name, email)
    funktion.call(mnr)
  ensure
    accountEntfernen(mnr, vorname, name, email) unless !angelegt
  end

  def mitSchule(funktion)
    name = testWort
    angelegt = schuleAnlegen(name)
    funktion.call(name)
  ensure
    schuleEntfernen(name) unless !angelegt
  end

  def schuleAnlegen(name)
    existiert = existiertSchule?(name)
    assert(!existiert, @fehler['vorSchule'])
    @db.query 'INSERT INTO schule (name, preferred_language, mail_suffix, use_shibboleth) VALUES (\'' + name + '\', \'DE\', \'\', 0)'
    angelegt = existiertSchule?(name)
    assert(angelegt, @fehler['nachSchule'])
    angelegt
  end

  def getSchule(name)
    schulen = @db.query 'SELECT * FROM schule WHERE name =\'' + name + '\''
    schulen.each_hash do |schule|
      return schule
    end
  end

  def schuleEntfernen(name)
    schulen = @db.query 'DELETE FROM schule WHERE name =\'' + name + '\''
  end

  def existiertSchule?(name)
    schulen = @db.query 'SELECT * FROM schule WHERE name =\'' + name + '\''
    schulen.num_rows > 0
  end

  def accountAnlegen(mnr, unr, vorname, name, email)
    existiert = existiertAccount?(mnr, vorname, name, email)
    assert(!existiert, @fehler['vorAccount'])
    @db.query 'INSERT INTO student (mnr, unr, name, vorname, email) VALUES (\'' + mnr + '\', \'' + unr + '\', \'' + name +  '\', \'' + vorname + '\', \'' + email + '\')'
    angelegt = existiertAccount?(mnr, vorname, name, email)
    assert(angelegt, @fehler['nachAccount'])
    angelegt
  end

  def setPassword(mnr, vorname, name, email)
    @db.query 'UPDATE student SET passwort=\'chkiekhnadijknnbaneblbklikeepmgbbgodniig\' WHERE mnr =\'' + mnr + '\' AND name = \'' + name +  '\' AND vorname = \'' + vorname + '\' AND email = \'' + email + '\''
  end

  def existiertAccount? (mnr, vorname, name, email)
    studenten = @db.query 'SELECT * FROM student WHERE mnr =\'' + mnr + '\' AND name = \'' + name +  '\' AND vorname = \'' + vorname + '\' AND email = \'' + email + '\''
    studenten.num_rows > 0
  end

  def accountEntfernen (mnr, vorname, name, email)
    rs = @db.query 'DELETE FROM student WHERE mnr =\'' + mnr + '\' AND name = \'' + name +  '\' AND vorname = \'' + vorname + '\' AND email = \'' + email + '\''
  end

  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def teardown
    @driver.quit
    @db.close
  end
end
