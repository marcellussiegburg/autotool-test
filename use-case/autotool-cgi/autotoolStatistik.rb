# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolStatistik < AutotoolAccount
  def einsendungBearbeitenGui(vorlesung, semester, aufgabe, student, einsendung, einsendungText)
    resultNeu = 'Pending'
    assert_operator(einsendung['Result'], :!=, resultNeu)
    assert_operator(readFile(einsendung['Report']), :!=, einsendungText)
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    click_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input", "Tutor")
    click_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input", "Aufgaben")
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", aufgabe['Name'])
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/input", "Statistics")
    @driver.find_elements(:xpath, "/html/body/form/table[8]/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == student['MNr'] then
        row.find_element(:xpath, "td[8]/input").click
        break
      end
    end
    @driver.find_element(:xpath, "/html/body/form/textarea").clear
    @driver.find_element(:xpath, "/html/body/form/textarea").send_key einsendungText
    click_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input", resultNeu)
    einsendungNeu = getEinsendung(einsendung['SNr'], einsendung['ANr'])
    assert_operator(einsendungNeu['Result'], :==, resultNeu)
#    assert_operator(readFile(einsendung['Report']), :==, einsendungText) # geht Nicht
  end

  def cacheLeerenGui(vorlesung, semester, aufgabe, student)
    existiert = existiertCache?(vorlesung['VNr'], aufgabe['ANr'], student['MNr'])
    assert(existiert, @fehler['keinCache'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    click_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input", "Tutor")
    click_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input", "Aufgaben")
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", aufgabe['Name'])
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/input", "Statistics")
    @driver.find_elements(:xpath, "/html/body/form/table[8]/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == student['MNr'] then
        row.find_element(:xpath, "td[9]/input").click
        break
      end
    end
    existiertNoch = existiertCache?(vorlesung['VNr'], aufgabe['ANr'], student['MNr'])
    assert(!existiertNoch, @fehler['nochCache'])
  end

  def aufgabeStatistikGui(vorlesung, semester, aufgabe, studenten)
    studs = studenten.clone.map { |stud| stud['SNr'] }
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    click_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input", "Tutor")
    click_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input", "Aufgaben")
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", aufgabe['Name'])
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/input", "Statistics")
    @driver.find_elements(:xpath, "/html/body/form/table[8]/tbody/tr").drop(1).each do |row|
      mnr = row.find_element(:xpath, "td[1]").text
      vorname = row.find_element(:xpath, "td[2]").text
      name = row.find_element(:xpath, "td[3]").text
      student = getStudentNoMail(mnr, vorname, name)
      if studs.include?(student['SNr']) then
        studs.delete(student['SNr'])
        einsendung = getEinsendung(student['SNr'], aufgabe['ANr'])
        assert_equal(row.find_element(:xpath, "td[4]").text, einsendung['Ok'])
        assert_equal(row.find_element(:xpath, "td[5]").text, einsendung['No'])
      end
    end
    assert(studs.empty?, @fehler['nachStatistik'])
  end
end
