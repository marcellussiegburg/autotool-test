require 'rubygems'
require_relative 'autotoolTest'

class AccountTest < AutotoolTest
  parallelize_me!()

  def test_accountAnlegen
    mnr = testWort
    vorname = testWort
    name = testWort
    email = @config['email']
    angelegt = accountAnlegenGui(mnr, vorname, name, email)
  ensure
    accountEntfernen(mnr, vorname, name, email) unless !angelegt
  end

  def test_login
    login = ->(schule, mnr) {
      login(schule['Name'], mnr)
    }
    mitSchuleAccount(login)
  end

  def test_logout
    logout = ->(schule, mnr) {
      login(schule['Name'], mnr)
      logout()
    }
    mitSchuleAccount(logout)
  end

  def accountAnlegenGui(mnr, vorname, name, email)
    existiert = existiertAccount?(mnr, vorname, name, email)
    assert_equal(false, existiert, 'Account existiert bereits')
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
    angelegt = existiertAccount?(mnr, vorname, name, email)
    assert_equal(true, angelegt, 'Account wurde nicht angelegt')
    angelegt
  end

  def login(schule, mnr)
    @driver.get(@base_url + "/cgi-bin/Super.cgi?school=" + schule)
    assert(!@driver.find_element(:tag_name, 'form').text.include?("Semester"), @fehler['vorLogin'])
    @driver.find_element(:id, @ui['loginButton']).click
    @driver.find_element(:id, @ui['loginMNr']).clear
    @driver.find_element(:id, @ui['loginMNr']).send_keys mnr
    @driver.find_element(:id, @ui['loginPasswort']).clear
    @driver.find_element(:id, @ui['loginPasswort']).send_keys 'foobar'
    @driver.find_element(:id, @ui['loginSubmit']).click
    assert(@driver.find_element(:tag_name, 'form').text.include?("Semester"), @fehler['nachLogin'])
  end

  def logout
    assert(@driver.find_element(:tag_name, 'form').text.include?("Semester"), @fehler['vorLogout'])
    @driver.get(@base_url + "/cgi-bin/Super.cgi?school=" + @config['schule'])
    assert(!@driver.find_element(:tag_name, 'form').text.include?("Semester"), @fehler['nachLogout'])
  end

end
