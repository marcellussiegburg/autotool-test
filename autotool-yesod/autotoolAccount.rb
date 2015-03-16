require_relative '../autotoolTest'

class AutotoolAccount < AutotoolTest
  def ensureTutor(schule, vorlesung, student, funktion)
    tutor = tutorAnlegen(student['SNr'], vorlesung['VNr'])
    ensureEingeloggt(schule['Name'], student['MNr'], funktion)
  ensure
    tutorEntfernen(student['SNr'], vorlesung['VNr']) unless !tutor
  end

  def ensureDirektor(schule, student, funktion)
    direktor = direktorAnlegen(student['SNr'], schule['UNr'])
    ensureEingeloggt(schule['Name'], student['MNr'], funktion)
  ensure
    direktorEntfernen(student['SNr'], schule['UNr']) unless !direktor
  end

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
    @driver.get(@config['url-yesod'] + "/auth/page/autotool/create")
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[1]").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[1]").send_keys mnr
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[2]").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[2]").send_keys vorname
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[3]").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[3]").send_keys name
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[4]").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[4]").send_keys email
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/button").click
    angelegt = existiertAccount?(mnr, vorname, name, email)
    assert(angelegt, @fehler['nachAccount'])
    angelegt
  end

  def login(schule, mnr)
    @driver.get(@config['url-yesod'] + "/auth/login")
    eingeloggt = @driver.find_element(:xpath, "/html/body/header/div/div/div[2]/ul[2]/li[1]/form/button").attribute('innerHTML').eql?("Abmelden")
    assert(!eingeloggt, @fehler['vorLogin'])
    select_element(:xpath, "/html/body/div/div/div[2]/form/select", schule)
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[1]").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[1]").send_keys mnr
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[2]").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/input[2]").send_keys 'foobar'
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/form/button").click
    eingeloggt2 = @driver.find_element(:xpath, "/html/body/header/div/div/div[2]/ul[2]/li[1]/form/button").attribute('innerHTML').eql?("Abmelden")
    assert(eingeloggt2, @fehler['nachLogin'])
    eingeloggt2
  end

  def logout
    @driver.get(@config['url-yesod'])
    if !@driver.find_element(:xpath, "/html/body/header/div/div/div[2]/ul[2]/li[1]/form/button").displayed? then
      @driver.find_element(:xpath, "/html/body/header/div/div/div[1]/button").click
    end
    @driver.find_element(:xpath, "/html/body/header/div/div/div[2]/ul[2]/li[1]/form/button").click
    eingeloggt = @driver.find_element(:xpath, "/html/body/header/div/div/div[2]/ul[2]/li[1]/form/button").attribute('innerHTML').eql?("Abmelden")
    assert(!eingeloggt, @fehler['nachLogout'])
  end
end
