require 'rubygems'
require_relative 'autotoolTest'

class AutotoolAccount < AutotoolTest
  def ensureAdmin(name, student, funktion)
    admin = adminAnlegen(student['SNr'])
    ensureEingeloggt(name, student['MNr'], funktion)
  ensure
    adminEntfernen(student['SNr']) unless !admin
  end

  def ensureEingeloggt(name, mnr, funktion)
    eingeloggt = login(name, mnr)
    funktion.call
  ensure
    logout() unless !eingeloggt
  end

  def accountAnlegenGui(mnr, vorname, name, email)
    existiert = existiertAccount?(mnr, vorname, name, email)
    assert(!existiert, @fehler['vorAccount'])
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
    assert(angelegt, @fehler['nachAccount'])
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
    eingeloggt = @driver.find_element(:tag_name, 'form').text.include?("Semester")
    assert(eingeloggt, @fehler['nachLogin'])
    eingeloggt
  end

  def logout
    @driver.get(@base_url + "/cgi-bin/Super.cgi?school=" + @config['schule'])
    assert(!@driver.find_element(:tag_name, 'form').text.include?("Semester"), @fehler['nachLogout'])
  end

end
