# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolEinsendung < AutotoolAccount
  def aufgabeLoesenGui(vorlesung, semester, aufgabe, student)
    existiert = existiertEinsendung?(student['SNr'], aufgabe['ANr'])
    assert(!existiert, @fehler['vorEinsendung'])
    einsendung = "e (j (b, i), (f (m (l (k, d), g), c (a, h))))"
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    click_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input", "Aufgaben")
    click_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input", "alle")
    @driver.find_elements(:xpath, "/html/body/form/table[7]/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == aufgabe['Name'] then
        row.find_element(:xpath, "td[7]/input").click
        break
      end
    end
    click_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input", "Textfeld")
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[1]/td/textarea").clear
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[1]/td/textarea").send_key einsendung
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[3]/td/input").click
    angelegt = existiertEinsendung?(student['SNr'], aufgabe['ANr'])
    assert(angelegt, @fehler['nachEinsendung'])
    angelegt
  ensure
    einsendungEntfernen(student, vorlesung['VNr'], aufgabe['ANr']) unless !angelegt
  end

  def vorherigeEinsendungGui(vorlesung, semester, aufgabe, student, einsendung)
    existiert = existiertEinsendung?(einsendung['SNr'], einsendung['ANr'])
    assert(existiert, @fehler['keineEinsendung'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    click_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input", "Aufgaben")
    click_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input", "alle")
    @driver.find_elements(:xpath, "/html/body/form/table[7]/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == aufgabe['Name'] then
        row.find_element(:xpath, "td[8]/input").click
        break
      end
    end
    angezeigt = @driver.find_element(:xpath, "/html/body/form").attribute('innerHTML').include?(readFile(einsendung['Report']))
    assert(angezeigt, @fehler['keineEinsendung'])
  end

  def aufgabeTestenGui(vorlesung, semester, aufgabe, student)
    existiert = existiertEinsendung?(student['SNr'], aufgabe['ANr'])
    assert(!existiert, @fehler['vorEinsendung'])
    einsendung = "e (j (b, i), (f (m (l (k, d), g), c (a, h))))"
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    click_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input", "Aufgaben")
    click_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input", "alle")
    @driver.find_elements(:xpath, "/html/body/form/table[7]/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == aufgabe['Name'] then
        row.find_element(:xpath, "td[7]/input").click
        break
      end
    end
    click_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input", "Textfeld")
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[1]/td/textarea").clear
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[1]/td/textarea").send_key einsendung
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[3]/td/input").click
    angezeigt = @driver.find_element(:xpath, "/html/body/form").attribute('innerHTML').include?(readFile('latest.report'))
    angelegt = existiertEinsendung?(student['SNr'], aufgabe['ANr'])
    assert(!angelegt, @fehler['keinTestEinsendung'])
    angelegt
  ensure
    einsendungEntfernen(student, vorlesung['VNr'], aufgabe['ANr']) unless !angelegt
  end
end
