# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolStatistik < AutotoolAccount
  def einsendungBearbeitenGui(vorlesung, semester, aufgabe, student, einsendung, einsendungText)
    resultNeu = 'Pending'
    assert_operator(einsendung['Result'], :!=, resultNeu)
    assert_operator(readFile(einsendung['Report']), :!=, einsendungText)
    @driver.get(@config['url-yesod'] + '/einsendung/' + aufgabe['ANr'] + '/' + student['SNr'])
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/textarea").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/textarea").send_key einsendungText
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/table/tbody/tr/td[3]/input").click
    @driver.find_element(:xpath, "/html/body/div/div/form/div[3]").click
    einsendungNeu = getEinsendung(einsendung['SNr'], einsendung['ANr'])
    assert_operator(einsendungNeu['Result'], :==, resultNeu)
    #assert_operator(readFile(einsendung['Report']), :==, einsendungText) # geht Nicht
  end

  def cacheLeerenGui(vorlesung, semester, aufgabe, student)
    existiert = existiertCache?(vorlesung['VNr'], aufgabe['ANr'], student['MNr'])
    assert(existiert, @fehler['keinCache'])
    @driver.get(@config['url-yesod'] + '/aufgabe/' + aufgabe['ANr'] + '/statistik')
    @driver.find_element(:xpath, "/html/body/div/div/form/table/tbody/tr/td[8]/button").click
    existiertNoch = existiertCache?(vorlesung['VNr'], aufgabe['ANr'], student['MNr'])
    assert(!existiertNoch, @fehler['nochCache'])
  end

  def aufgabeStatistikGui(vorlesung, semester, aufgabe, studenten)
    studs = studenten.clone.map { |stud| stud['SNr'] }
    @driver.get(@config['url-yesod'] + '/aufgabe/' + aufgabe['ANr'] + '/statistik')
    @driver.find_elements(:xpath, "/html/body/div/div/form/table/tbody/tr").each do |row|
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
