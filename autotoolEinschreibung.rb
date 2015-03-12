# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolEinschreibung < AutotoolAccount
  def einschreibenGui(vorlesung, semester, gruppe, student)
    existiert = existiertEinschreibung?(student['SNr'], gruppe['GNr'])
    assert(!existiert, @fehler['vorEinschreibung'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    click_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input", "Einschreibung")
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", gruppe['Name'] + " besuchen")
    angelegt = existiertEinschreibung?(student['SNr'], gruppe['GNr'])
    assert(angelegt, @fehler['nachEinschreibung'])
    angelegt
  ensure
    einschreibungEntfernen(student['SNr'], gruppe['GNr']) unless !angelegt
  end

  def austragenGui(vorlesung, semester, gruppe, student)
    existiert = existiertEinschreibung?(student['SNr'], gruppe['GNr'])
    assert(existiert, @fehler['keineEinschreibung'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    click_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input", "Einschreibung")
    click_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[2]/input", gruppe['Name'] + " verlassen")
    existiertNoch = existiertEinschreibung?(student['SNr'], gruppe['GNr'])
    assert(!existiertNoch, @fehler['nochEinschreibung'])
  end
end
