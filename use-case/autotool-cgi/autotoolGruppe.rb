# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolGruppe < AutotoolAccount
  def gruppeAnlegenGui(vorlesung, semester, name, maxStudenten, referent)
    existiert = existiertGruppe?(vorlesung['VNr'], name, maxStudenten, referent)
    assert(!existiert, @fehler['vorGruppe'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr[1]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr[1]/td[2]/input").send_key name
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr[2]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr[2]/td[2]/input").send_key referent
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr[3]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr[3]/td[2]/input").send_key maxStudenten
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[3].click
    angelegt = existiertGruppe?(vorlesung['VNr'], name, maxStudenten, referent)
    assert(angelegt, @fehler['nachGruppe'])
    angelegt
  ensure
    gruppeEntfernen(vorlesung['VNr'], name, maxStudenten, referent) unless !angelegt
  end

  def gruppeBearbeitenGui(gruppe, vorlesung, semester, name, maxStudenten, referent)
    existiert = existiertGruppe?(gruppe['VNr'], gruppe['Name'], gruppe['MaxStudents'], gruppe['Referent'])
    assert(existiert, @fehler['keineGruppe'])
    existiertNeu = existiertGruppe?(vorlesung['VNr'], name, maxStudenten, referent)
    assert(!existiertNeu, @fehler['vorGruppe'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[2]/input[3]").click
    click_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input", gruppe['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[1]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[1]/td[2]/input").send_key name
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[2]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[2]/td[2]/input").send_key referent
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[3]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[3]/td[2]/input").send_key maxStudenten
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[3].click
    existiertNeu2 = existiertGruppe?(vorlesung['VNr'], name, maxStudenten, referent)
    assert(existiertNeu2, @fehler['keineGruppe'])
    assert_equal(gruppe['GNr'], getGruppe(vorlesung['VNr'], name, maxStudenten, referent)['GNr'], @fehler['nichtBearbeitetGruppe'])
  ensure
    gruppeEntfernen(vorlesung['VNr'], name, maxStudenten, referent) unless !existiertNeu2
  end

  def gruppeEntfernenGui(gruppe, vorlesung, semester)
    existiert = existiertGruppe?(gruppe['VNr'], gruppe['Name'], gruppe['MaxStudents'], gruppe['Referent'])
    assert(existiert, @fehler['keineGruppe'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[2]/input[4]").click
    click_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input", gruppe['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr[2]/td/input").click
    existiertNoch = existiertGruppe?(gruppe['VNr'], gruppe['Name'], gruppe['MaxStudents'], gruppe['Referent'])
    assert(!existiertNoch, @fehler['nochGruppe'])
  end
end
