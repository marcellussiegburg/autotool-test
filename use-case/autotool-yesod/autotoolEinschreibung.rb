# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolEinschreibung < AutotoolAccount
  def einschreibenGui(vorlesung, semester, gruppe, student)
    existiert = existiertEinschreibung?(student['SNr'], gruppe['GNr'])
    assert(!existiert, @fehler['vorEinschreibung'])
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'] + '/gruppen')
    @driver.find_elements(:xpath, "/html/body/div/div/table/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == gruppe['Name'] then
        row.find_element(:xpath, "td[5]/form/div[2]/button").click
        break
      end
    end
    angelegt = existiertEinschreibung?(student['SNr'], gruppe['GNr'])
    assert(angelegt, @fehler['nachEinschreibung'])
    angelegt
  ensure
    einschreibungEntfernen(student['SNr'], gruppe['GNr']) unless !angelegt
  end

  def austragenGui(vorlesung, semester, gruppe, student)
    existiert = existiertEinschreibung?(student['SNr'], gruppe['GNr'])
    assert(existiert, @fehler['keineEinschreibung'])
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'] + '/gruppen')
    @driver.find_elements(:xpath, "/html/body/div/div/table/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == gruppe['Name'] then
        row.find_element(:xpath, "td[5]/form/div[2]/button").click
        break
      end
    end
    existiertNoch = existiertEinschreibung?(student['SNr'], gruppe['GNr'])
    assert(!existiertNoch, @fehler['nochEinschreibung'])
  end
end
