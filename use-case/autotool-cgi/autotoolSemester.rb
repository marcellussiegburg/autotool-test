require_relative 'autotoolAccount'

class AutotoolSemester < AutotoolAccount
  def semesterAnlegenGui(schule, name)
    existiert = existiertSemester?(schule['UNr'], name)
    assert(!existiert, @fehler['vorSemester'])
    @driver.find_element(:xpath, "/html/body/form/table[3]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input", schule['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[3]").click
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[1]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[1]/td[2]/input").send_key name
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/select[1]", anfang.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/select[2]", monate[anfang.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/select[3]", anfang.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/select[4]", anfang.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/select[5]", anfang.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/select[6]", anfang.strftime('%S'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[3]/td[2]/select[1]", ende.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[3]/td[2]/select[2]", monate[ende.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[3]/td[2]/select[3]", ende.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[3]/td[2]/select[4]", ende.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[3]/td[2]/select[5]", ende.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[3]/td[2]/select[6]", ende.strftime('%S'))
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
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
    @driver.find_element(:xpath, "/html/body/form/table[3]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input", schule['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", semester['Name'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[1]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[1]/td[2]/input").send_key name
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/select[1]", anfang.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/select[2]", monate[anfang.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/select[3]", anfang.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/select[4]", anfang.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/select[5]", anfang.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/select[6]", anfang.strftime('%S'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/select[1]", ende.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/select[2]", monate[ende.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/select[3]", ende.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/select[4]", ende.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/select[5]", ende.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/select[6]", ende.strftime('%S'))
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existiertNeu2 = existiertSemester?(schule['UNr'], name)
    assert(existiertNeu2, @fehler['keinSemester'])
    assert_equal(semester['ENr'], getSemester(schule['UNr'], name)['ENr'], @fehler['nichtBearbeitetSchule'])
  ensure
    semesterEntfernen(schule['UNr'], semester['Name']) unless !existiert
    semesterEntfernen(schule['UNr'], name) unless !existiertNeu2
  end
end
