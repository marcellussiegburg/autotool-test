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

  def test_accountAnlegen
    mnr = testWort
    vorname = testWort
    name = testWort
    email = @config['email']
    assert_equal(false, existiertAccount?(mnr, vorname, name, email))
    accountAnlegen(mnr, vorname, name, email)
    assert_equal(true, existiertAccount?(mnr, vorname, name, email))
    accountEntfernen(mnr, vorname, name, email)
  end

  def accountAnlegen (mnr, vorname, name, email)
    @driver.get(@base_url + "/cgi-bin/Super.cgi?school=" + @config['schule'])
    @driver.find_element(:id, @ui['accountAnlegenButton']).click
    @driver.find_element(:id, @ui['accountAnlegenMNr']).clear
    @driver.find_element(:id, @ui['accountAnlegenMNr']).send_keys mnr
    @driver.find_element(:id, @ui['accountAnlegenVorname']).clear
    @driver.find_element(:id, @ui['accountAnlegenVorname']).send_keys vorname
    @driver.find_element(:id, @ui['accountAnlegenName']).clear
    @driver.find_element(:id, @ui['accountAnlegenName']).send_keys name
    @driver.find_element(:id, @ui['accountAnlegenEmail']).clear
    @driver.find_element(:id, @ui['accountAnlegenEmail']).send_keys email
    @driver.find_element(:id, @ui['accountAnlegenSubmit1']).click
    @driver.find_element(:id, @ui['accountAnlegenSubmit2']).click
  end

  def existiertAccount? (mnr, vorname, name, email)
    studenten = @db.query 'SELECT * FROM student WHERE mnr =\'' + mnr + '\' AND name = \'' + name +  '\' AND vorname = \'' + vorname + '\' AND email = \'' + email + '\''
    studenten.num_rows > 0
  end

  def accountEntfernen (mnr, vorname, name, email)
    rs = @db.query 'DELETE FROM student WHERE mnr =\'' + mnr + '\' AND name = \'' + name +  '\' AND vorname = \'' + vorname + '\' AND email = \'' + email + '\''
  end

  def teardown
    @driver.quit
    @db.close
  end
end
