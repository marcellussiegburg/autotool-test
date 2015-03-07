# -*- coding: utf-8 -*-
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
    sleep(5)
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

  def mitVorlesung(enr, unr, funktion)
    name = testWort
    motd = testWort
    semesterAnlegen(enr, name, unr, motd)
    vorlesung = getVorlesung(enr, name, unr, motd)
    funktion.call(vorlesung)
  ensure
    vorlesungEntfernen(enr, name, unr, motd)
  end

  def mitSemester(unr, funktion)
    name = testWort
    semesterAnlegen(unr, name)
    semester = getSemester(unr, name)
    funktion.call(semester)
  ensure
    semesterEntfernen(unr, name)
  end

  def mitSchuleAccount(funktion)
    mitSchule(->(name) {
      schule = getSchule(name)
      mitAccount(schule['UNr'], ->(student) {
        funktion.call(schule, student)
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
    student = getStudent(mnr, vorname, name, email)
    funktion.call(student)
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

  def tutorAnlegen(snr, vnr)
    existiert = existiertTutor?(snr, vnr)
    assert(!existiert, @fehler['vorTutor'])
    @db.query 'INSERT INTO tutor (SNr, VNr) VALUES (' + snr + ',' + vnr + ')'
    angelegt = existiertTutor?(snr, vnr)
    assert(angelegt, @fehler['nachTutor'])
    angelegt
  end

  def tutorEntfernen(snr, vnr)
    tutoren = @db.query 'DELETE FROM tutor WHERE SNr =' + snr + ' AND VNr = ' + vnr
  end

  def existiertTutor?(snr, vnr)
    tutoren = @db.query 'SELECT * FROM tutor WHERE SNr = ' + snr + ' AND VNr = ' + vnr
    tutoren.num_rows > 0
  end

  def direktorAnlegen(snr, unr)
    existiert = existiertDirektor?(snr, unr)
    assert(!existiert, @fehler['vorDirektor'])
    @db.query 'INSERT INTO direktor (SNr, UNr) VALUES (' + snr + ',' + unr + ')'
    angelegt = existiertDirektor?(snr, unr)
    assert(angelegt, @fehler['nachDirektor'])
    angelegt
  end

  def direktorEntfernen(snr, unr)
    direktoren = @db.query 'DELETE FROM direktor WHERE SNr =' + snr + ' AND UNr = ' + unr
  end

  def existiertDirektor?(snr, unr)
    direktoren = @db.query 'SELECT * FROM direktor WHERE SNr = ' + snr + ' AND UNr = ' + unr
    direktoren.num_rows > 0
  end

  def adminAnlegen(snr)
    existiert = existiertAdmin?(snr)
    assert(!existiert, @fehler['vorAdmin'])
    @db.query 'INSERT INTO minister (SNr) VALUES (' + snr + ')'
    angelegt = existiertAdmin?(snr)
    assert(angelegt, @fehler['nachAdmin'])
    angelegt
  end

  def adminEntfernen(snr)
    administratoren = @db.query 'DELETE FROM minister WHERE SNr = ' + snr
  end

  def existiertAdmin?(snr)
    administratoren = @db.query 'SELECT * FROM minister WHERE SNr = ' + snr
    administratoren.num_rows > 0
  end

  def vorlesungAnlegen(enr, name, unr, motd)
    existiert = existiertVorlesung?(enr, name, unr, motd)
    assert(!existiert, @fehler['vorVorlesung'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    @db.query 'INSERT INTO vorlesung (ENr, Name, EinschreibVon, EinschreibBis, unr, motd) VALUES (' + enr + ', \'' + name + '\', \'' + anfang.strftime('%Y-%m-%d %H:%M:%S') + '\', \'' + ende.strftime('%Y-%m-%d %H:%M:%S') + '\', ' + unr + ', \'' + motd + '\')'
    angelegt = existiertVorlesung?(enr, name, unr, motd)
    assert(angelegt, @fehler['nachVorlesung'])
    angelegt
  end

  def getVorlesung(enr, name, unr, motd)
    vorlesungen = @db.query 'SELECT * FROM vorlesung WHERE UNr = ' + enr + ' AND Name = \'' + name + '\'' + unr + ' AND Name = \'' + motd + '\''
    vorlesungen.each_hash do |vorlesung|
      return vorlesung
    end
  end

  def existiertVorlesung?(enr, name, unr, motd)
    vorlesungen = @db.query 'SELECT * FROM vorlesung WHERE UNr = ' + enr + ' AND Name = \'' + name + '\'' + unr + ' AND Name = \'' + motd + '\''
    vorlesungen.num_rows > 0
  end

  def vorlesungenEntfernen(enr, name, unr, motd)
    vorlesungen = @db.query 'DELETE FROM vorlesung WHERE UNr = ' + enr + ' AND Name = \'' + name + '\'' + unr + ' AND Name = \'' + motd + '\''
  end

  def semesterAnlegen(unr, name)
    existiert = existiertSemester?(unr, name)
    assert(!existiert, @fehler['vorSemester'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    @db.query 'INSERT INTO semester (UNr, Name, Von, Bis) VALUES (' + unr + ', \'' + name + '\', \'' + anfang.strftime('%Y-%m-%d %H:%M:%S') + '\', \'' + ende.strftime('%Y-%m-%d %H:%M:%S') + '\')'
    angelegt = existiertSemester?(unr, name)
    assert(angelegt, @fehler['nachSemester'])
    angelegt
  end

  def getSemester(unr, name)
    semesters = @db.query 'SELECT * FROM semester WHERE UNr = ' + unr + ' AND Name = \'' + name + '\''
    semesters.each_hash do |semester|
      return semester
    end
  end

  def existiertSemester?(unr, name)
    semesters = @db.query 'SELECT * FROM semester WHERE UNr = ' + unr + ' AND Name = \'' + name + '\''
    semesters.num_rows > 0
  end

  def semesterEntfernen(unr, name)
    semesters = @db.query 'DELETE FROM semester WHERE UNr = ' + unr + ' AND Name = \'' + name + '\''
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
    @db.query 'INSERT INTO student (mnr, unr, name, vorname, email) VALUES (\'' + mnr + '\', ' + unr + ', \'' + name +  '\', \'' + vorname + '\', \'' + email + '\')'
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

  def getStudent (mnr, vorname, name, email)
    studenten = @db.query 'SELECT * FROM student WHERE mnr =\'' + mnr + '\' AND name = \'' + name +  '\' AND vorname = \'' + vorname + '\' AND email = \'' + email + '\''
    studenten.each_hash do |student|
      return student
    end
  end

  def accountEntfernen (mnr, vorname, name, email)
    rs = @db.query 'DELETE FROM student WHERE mnr =\'' + mnr + '\' AND name = \'' + name +  '\' AND vorname = \'' + vorname + '\' AND email = \'' + email + '\''
  end

  def select_element(how, what, option)
    @driver.find_element(how, what).send_key option
  end

  def click_element(how, what, option)
    @driver.find_elements(how, what).find do |button|
       button.attribute('value') == option
    end.click
  end

  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def monate
    return {
      "00" => nil,
      "01" => "Januar",
      "02" => "Februar",
      "03" => "März",
      "04" => "April",
      "05" => "Mai",
      "06" => "Juni",
      "07" => "Juli",
      "08" => "August",
      "09" => "September",
      "10" => "Oktober",
      "11" => "November",
      "12" => "Dezember"}
  end

  def teardown
    @driver.quit
    @db.close
  end
end
