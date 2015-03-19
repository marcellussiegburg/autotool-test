# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolDirektor < AutotoolAccount
  def direktorErnennen(schule, student)
    existiert = existiertDirektor?(student['SNr'], schule['UNr'])
    assert(!existiert, @fehler['vorDirektor'])
    @driver.get(@config['url-yesod'] + '/schule/' + schule['UNr'] + '/direktor')
    @driver.find_elements(:xpath, "/html/body/div/div/table/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == student['SNr'] then
        row.find_element(:xpath, "td[6]/form/div[2]/button").click
        break
      end
    end
    angelegt = existiertDirektor?(student['SNr'], schule['UNr'])
    assert(angelegt, @fehler['nachDirektor'])
    angelegt
  ensure
    direktorEntfernen(student['SNr'], schule['UNr']) unless !angelegt
  end

  def direktorAbsetzen(schule, student)
    existiert = existiertDirektor?(student['SNr'], schule['UNr'])
    assert(existiert, @fehler['keinDirektor'])
    @driver.get(@config['url-yesod'] + '/schule/' + schule['UNr'] + '/direktoren')
    @driver.find_elements(:xpath, "/html/body/div/div/table/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == student['SNr'] then
        row.find_element(:xpath, "td[6]/form/div[2]/button").click
        break
      end
    end
    existiertNoch = existiertDirektor?(student['SNr'], schule['UNr'])
    assert(!existiertNoch, @fehler['nochDirektor'])
  ensure
      direktorEntfernen(student['SNr'], schule['UNr'])
  end
end
