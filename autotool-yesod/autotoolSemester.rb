require_relative 'autotoolAccount'

class AutotoolSemester < AutotoolAccount
  def semesterAnlegenGui(schule, name)
    existiert = existiertSemester?(schule['UNr'], name)
    assert(!existiert, @fehler['vorSemester'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    @driver.get(@config['url-yesod'] + '/schule/' + schule['UNr'] + '/semester')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[1]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[2]/input").send_key anfang.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[3]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[3]/input").send_key anfang.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[4]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[4]/input").send_key ende.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[5]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[5]/input").send_key ende.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[6]/button").click
    angelegt = existiertSemester?(schule['UNr'], name)
    assert(angelegt, @fehler['nachSemester'])
    angelegt
  ensure
    semesterEntfernen(schule['UNr'], name) unless !angelegt
  end

  def semesterBearbeitenGui(schule, semester, name)
    existiert = existiertSemester?(schule['UNr'], semester['Name'])
    assert(existiert, @fehler['keinSemester'])
    existiertNeu = existiertSemester?(schule['UNr'], name)
    assert(!existiertNeu, @fehler['vorSemester'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    @driver.get(@config['url-yesod'] + '/semester/' + semester['ENr'])
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[1]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[2]/input").send_key anfang.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[3]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[3]/input").send_key anfang.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[4]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[4]/input").send_key ende.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[5]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[5]/input").send_key ende.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[6]/button").click
    existiertNeu2 = existiertSemester?(schule['UNr'], name)
    assert(existiertNeu2, @fehler['keinSemester'])
    assert_equal(semester['ENr'], getSemester(schule['UNr'], name)['ENr'], @fehler['nichtBearbeitetSchule'])
  ensure
    semesterEntfernen(schule['UNr'], semester['Name']) unless !existiert
    semesterEntfernen(schule['UNr'], name) unless !existiertNeu2
  end
end
