# -*- coding: utf-8 -*-
require 'rubygems'
gem 'minitest'
require 'fileutils'
require 'minitest/autorun'
require 'selenium-webdriver'
require 'mysql'
require 'yaml'

class AutotoolTest < MiniTest::Test
  def initialize(arg)
    super(arg)
    @failure = 0
  end

  def setup
    number = rand(100) + 100 * ENV['TEST_ENV_NUMBER'].to_i
    @config = YAML.load_file '../config.yaml'
    @ui = YAML.load_file 'ui.yaml'
    @fehler = YAML.load_file '../fehler.yaml'
    @base_url = @config['url']
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['webdriver_firefox_port'] = 7000 + number
    profile.native_events = false
    profile['general.useragent.override'] = zufallsWort(60)
    capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
    @driver = Selenium::WebDriver.for(:remote, :desired_capabilities => capabilities)
    @db = Mysql.new @config['dbServer'], @config['dbUser'], @config['dbPasswort'], @config['db']
  rescue NameError, Timeout::Error
    if @failure < 20 then
      @failure = @failure + 1
      STDOUT.print '_'
      STDOUT.flush
      sleep(10)
      setup
    else
      raise
    end
  rescue Selenium::WebDriver::Error::WebDriverError
    if @failure < 20 then
      @failure = @failure + 1
      STDOUT.print '-'
      STDOUT.flush
      setup
    else
      raise
    end
  end

  def zufallsWort(laenge)
    chars = [('a'..'z').to_a, ('A'..'Z').to_a].flatten
    (1..laenge).map {chars[rand(chars.length)]}.join
  end

  def testWort
    "TEST" + zufallsWort(8)
  end

  def mitCache(vnr, anr, mnr, funktion)
    cacheAnlegen(vnr, anr, mnr)
    funktion.call()
  ensure
    cacheEntfernen(vnr)
  end

  def mitEinsendungen(studenten, vnr, anrs, funktion)
    if studenten.size == 1 and anrs.size == 1 then
      mitEinsendung studenten.shift, vnr, anrs.shift, ->(einsendung) {
        funktion.call()
      }
    elsif studenten.size > 1 then
      mitEinsendungen([studenten.shift], vnr, anrs, ->() {mitEinsendungen(studenten, vnr, anrs, funktion)})
    elsif anrs.size > 1 then
      mitEinsendungen(studenten, vnr, [anrs.shift], ->() {mitEinsendungen(studenten, vnr, anrs, funktion)})
    else
      funktion.call()
    end
  end

  def mitEinsendung(student, vnr, anr, funktion)
    einsendungAnlegen(student, vnr, anr)
    einsendung = getEinsendung(student['SNr'], anr)
    funktion.call(einsendung)
  ensure
    einsendungEntfernen(student, vnr, anr)
  end

  def mitEinschreibungen(snrs, gnr, funktion)
    if snrs.size > 0 then
      mitEinschreibung(snrs.shift, gnr, ->() { mitEinschreibungen(snrs, gnr, funktion) })
    else
      funktion.call()
    end
  end

  def mitEinschreibung(snr, gnr, funktion)
    einschreibungAnlegen(snr, gnr)
    funktion.call()
  ensure
    einschreibungEntfernen(snr, gnr)
  end

  def mitAufgaben(x, vnr, funktion)
    mitAufgabenHelper(x, vnr, [], funktion)
  end

  def mitAufgabenHelper(x, vnr, aufgaben, funktion)
    if x > 0 then
      mitAufgabe vnr, ->(aufgabe) {
        mitAufgabenHelper(x - 1, vnr, aufgaben + [aufgabe], funktion)
      }
    else
      funktion.call(aufgaben)
    end
  end

  def mitAufgabe(vnr, funktion)
    name = testWort
    hinweis = testWort
    aufgabeAnlegen(vnr, name, hinweis)
    aufgabe = getAufgabe(vnr, name, hinweis)
    funktion.call(aufgabe)
  ensure
    aufgabeEntfernen(vnr, name, hinweis)
  end

  def mitGruppe(vnr, funktion)
    name = testWort
    referent = testWort
    maxStudenten = (5 + rand(50)).to_s
    gruppeAnlegen(vnr, name, maxStudenten, referent)
    gruppe = getGruppe(vnr, name, maxStudenten, referent)
    funktion.call(gruppe)
  ensure
    gruppeEntfernen(vnr, name, maxStudenten, referent)
  end

  def mitVorlesung(enr, unr, funktion)
    name = testWort
    motd = testWort
    vorlesungAnlegen(enr, name, unr, motd)
    vorlesung = getVorlesung(enr, name, unr, motd)
    vorlesungOrdnerAnlegen(vorlesung['VNr'])
    funktion.call(vorlesung)
  ensure
    vorlesungEntfernen(enr, name, unr, motd)
    vorlesungOrdnerEntfernen(vorlesung['VNr'])
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

  def mitStudenten(x, unr, funktion)
    mitStudentenHelper(x, unr, [], funktion)
  end

  def mitStudentenHelper(x, unr, studenten, funktion)
    if x > 0 then
      mitAccount unr, ->(student) {
        mitStudentenHelper(x - 1, unr, [student] + studenten, funktion)
      }
    else
      funktion.call(studenten)
    end
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

  def einschreibungAnlegen(snr, gnr)
    existiert = existiertEinschreibung?(snr, gnr)
    assert(!existiert, @fehler['vorEinschreibung'])
    @db.query 'INSERT INTO stud_grp (SNr, GNr) VALUES (' + snr + ',' + gnr + ')'
    angelegt = existiertEinschreibung?(snr, gnr)
    assert(angelegt, @fehler['nachEinschreibung'])
    angelegt
  end

  def einschreibungEntfernen(snr, gnr)
    einschreibungen = @db.query 'DELETE FROM stud_grp WHERE SNr = ' + snr + ' AND GNr = ' + gnr
  end

  def existiertEinschreibung?(snr, gnr)
    einschreibungen = @db.query 'SELECT * FROM stud_grp WHERE SNr = ' + snr + ' AND GNr = ' + gnr
    einschreibungen.num_rows > 0
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

  def cacheAnlegen(vnr, anr, mnr)
    pfad = '/space/autotool/cache/' + vnr + '/' + anr
    unless File.directory?(pfad)
      FileUtils.mkdir_p(pfad, :mode => 0777)
    end
    datei = pfad + '/' + mnr + '.cache'
    FileUtils.touch(datei)
    FileUtils.chmod(0777, datei)
  end

  def cacheEntfernen(vnr)
    pfad = '/space/autotool/cache/' + vnr
    FileUtils.rm_r(pfad, :force => true)
  end

  def existiertCache?(vnr, anr, mnr)
    datei = '/space/autotool/cache/' + vnr + '/' + anr + '/' + mnr + '.cache'
    File.file?(datei)
  end

  def aufgabeAlsAbgelaufen(aufgabe)
    anfang = Time.now - (60 * 60 * 24 * 31)
    ende = Time.now - 1
    @db.query 'UPDATE aufgabe SET Von = \'' + anfang.strftime('%Y-%m-%d %H:%M:%S') + '\', Bis = \'' + ende.strftime('%Y-%m-%d %H:%M:%S') + '\' WHERE ANr = ' + aufgabe['ANr']
  end

  def aufgabeAnlegen(vnr, name, hinweis)
    existiert = existiertAufgabe?(vnr, name, hinweis)
    assert(!existiert, @fehler['vorAufgabe'])
    server = "http://kernkraft.imn.htwk-leipzig.de/cgi-bin/autotool-latest.cgi"
    typ = "Reconstruct-Direct"
    highscore = "High"
    status = "Demo"
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    config = "[ ( Pre
  , [ e , j , b , i , f , m , l
    , k , d , g , c , a , h ] )
, ( In
  , [ b , j , i , e , k , l , d
    , m , g , f , a , c , h ] ) ]"
    @db.query 'INSERT INTO aufgabe (VNr, Name, Von, Bis, server, Typ, Highscore, Status, Config, Remark) VALUES (' + vnr + ', \'' + name + '\', \'' + anfang.strftime('%Y-%m-%d %H:%M:%S') + '\', \'' + ende.strftime('%Y-%m-%d %H:%M:%S') + '\', \'' + server + '\', \'' + typ + '\', \'' + highscore + '\', \'' + status + '\', \'' + config + '\', \'' + hinweis + '\')'
    angelegt = existiertAufgabe?(vnr, name, hinweis)
    assert(angelegt, @fehler['nachAufgabe'])
    angelegt
  end

  def getAufgabe(vnr, name, hinweis)
    aufgaben = @db.query 'SELECT * FROM aufgabe WHERE VNr = ' + vnr + ' AND Name = \'' + name + '\' AND Remark = \'' + hinweis + '\''
    aufgaben.each_hash do |aufgabe|
      return aufgabe
    end
  end

  def existiertAufgabe?(vnr, name, hinweis)
    aufgaben = @db.query 'SELECT * FROM aufgabe WHERE VNr = ' + vnr + ' AND Name = \'' + name + '\' AND Remark = \'' + hinweis + '\''
    aufgaben.num_rows > 0
  end

  def aufgabeEntfernen(vnr, name, hinweis)
    aufgaben = @db.query 'DELETE FROM aufgabe WHERE VNr = ' + vnr + ' AND Name = \'' + name + '\' AND Remark = \'' + hinweis + '\''
  end

  def vorlesungOrdnerAnlegen(vnr)
    pfad = '/space/autotool/done/' + vnr
    unless File.directory?(pfad)
      FileUtils.mkdir_p(pfad, :mode => 0777)
    end
  end

  def vorlesungOrdnerEntfernen(vnr)
    pfad = '/space/autotool/done/' + vnr
    FileUtils.rm_r(pfad, :force => true)
  end

  def einsendungAnlegen(student, vnr, anr)
    oks = rand(1000) + 1
    nos = rand(1000)
    pfad = '/space/autotool/done/' + vnr + '/' + anr + '/' + student['MNr'] + '/OK'
    unless File.directory?(pfad)
      FileUtils.mkdir_p(pfad, :mode => 0777)
    end
    input = pfad + '/latest.input'
    report = pfad + '/latest.report'
    instant = pfad + '/latest.instant'
    FileUtils.cp('../latest.input', input)
    FileUtils.cp('../latest.report', report)
    FileUtils.cp('../latest.instant', instant)
    FileUtils.chmod(0777, input)
    FileUtils.chmod(0777, report)
    FileUtils.chmod(0777, instant)
    existiert = existiertEinsendung?(student['SNr'], anr)
    assert(!existiert, @fehler['vorEinsendung'])
    @db.query 'INSERT INTO stud_aufg (SNr, ANr, Ok, No, Input, Report, Instant) VALUES (' + student['SNr'] + ', ' + anr + ', ' + oks.to_s + ', ' + nos.to_s + ', \'' + input + '\', \'' + report + '\', \'' + instant + '\')'
    angelegt = existiertEinsendung?(student['SNr'], anr)
    assert(angelegt, @fehler['nachEinsendung'])
    angelegt
  end

  def getEinsendung(snr, anr)
    einsendungen = @db.query 'SELECT * FROM stud_aufg WHERE SNr = ' + snr + ' AND ANr = ' + anr
    einsendungen.each_hash do |einsendung|
      return einsendung
    end
  end

  def existiertEinsendung?(snr, anr)
    einsendungen = @db.query 'SELECT * FROM stud_aufg WHERE SNr = ' + snr + ' AND ANr = ' + anr
    einsendungen.num_rows > 0
  end

  def einsendungEntfernen(student, vnr, anr)
    pfad = '/space/autotool/done/' + vnr
    einsendungen = @db.query 'DELETE FROM stud_aufg WHERE SNr = ' + student['SNr'] + ' AND ANr = ' + anr
    FileUtils.rm_r pfad, :force => true
  end

  def gruppeAnlegen(vnr, name, maxStudenten, referent)
    existiert = existiertGruppe?(vnr, name, maxStudenten, referent)
    assert(!existiert, @fehler['vorGruppe'])
    @db.query 'INSERT INTO gruppe (VNr, Name, MaxStudents, Referent) VALUES (' + vnr + ', \'' + name + '\', ' + maxStudenten + ', \'' + referent + '\')'
    angelegt = existiertGruppe?(vnr, name, maxStudenten, referent)
    assert(angelegt, @fehler['nachGruppe'])
    angelegt
  end

  def getGruppe(vnr, name, maxStudenten, referent)
    gruppen = @db.query 'SELECT * FROM gruppe WHERE VNr = ' + vnr + ' AND Name = \'' + name + '\' AND MaxStudents = ' + maxStudenten + ' AND referent = \'' + referent + '\''
    gruppen.each_hash do |gruppe|
      return gruppe
    end
  end

  def existiertGruppe?(vnr, name, maxStudenten, referent)
    gruppen = @db.query 'SELECT * FROM gruppe WHERE VNr = ' + vnr + ' AND Name = \'' + name + '\' AND MaxStudents = ' + maxStudenten + ' AND referent = \'' + referent + '\''
    gruppen.num_rows > 0
  end

  def gruppeEntfernen(vnr, name, maxStudenten, referent)
    gruppen = @db.query 'DELETE FROM gruppe WHERE VNr = ' + vnr + ' AND Name = \'' + name + '\' AND MaxStudents = ' + maxStudenten + ' AND referent = \'' + referent + '\''
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
    vorlesungen = @db.query 'SELECT * FROM vorlesung WHERE ENr = ' + enr + ' AND Name = \'' + name + '\' AND unr = ' + unr + ' AND motd = \'' + motd + '\''
    vorlesungen.each_hash do |vorlesung|
      return vorlesung
    end
  end

  def existiertVorlesung?(enr, name, unr, motd)
    vorlesungen = @db.query 'SELECT * FROM vorlesung WHERE ENr = ' + enr + ' AND Name = \'' + name + '\' AND unr = ' + unr + ' AND motd = \'' + motd + '\''
    vorlesungen.num_rows > 0
  end

  def vorlesungEntfernen(enr, name, unr, motd)
    vorlesungen = @db.query 'DELETE FROM vorlesung WHERE ENr = ' + enr + ' AND Name = \'' + name + '\' AND unr = ' + unr + ' AND motd = \'' + motd + '\''
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

  def getStudentNoMail (mnr, vorname, name)
    studenten = @db.query 'SELECT * FROM student WHERE mnr =\'' + mnr + '\' AND name = \'' + name +  '\' AND vorname = \'' + vorname + '\''
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

  def readFile(datei)
    file = File.open(datei, "r")
    inhalt = file.read
    file.close
    inhalt
  end

  def teardown
    @driver.quit
    @db.close
  end
end
