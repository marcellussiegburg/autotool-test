# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolTutor < AutotoolAccount
  def tutorErnennen(vorlesung, semester, schule, student)
    existiert = existiertTutor?(student['SNr'], vorlesung['VNr'])
    assert(!existiert, @fehler['vorTutor'])
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'] + '/tutor')
    @driver.find_elements(:xpath, "/html/body/div/div/table/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == student['SNr'] then
        row.find_element(:xpath, "td[6]/form/div[2]/button").click
        break
      end
    end
    angelegt = existiertTutor?(student['SNr'], vorlesung['VNr'])
    assert(angelegt, @fehler['nachTutor'])
  ensure
    tutorEntfernen(vorlesung['VNr'], student['SNr']) unless !angelegt
  end

  def tutorAbsetzen(vorlesung, semester, schule, student)
    existiert = existiertTutor?(student['SNr'], vorlesung['VNr'])
    assert(existiert, @fehler['keinTutor'])
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'] + '/tutoren')
    @driver.find_elements(:xpath, "/html/body/div/div/table/tbody/tr").each do |row|
      if row.find_element(:xpath, "td[1]").text == student['SNr'] then
        row.find_element(:xpath, "td[6]/form/div[2]/button").click
        break
      end
    end
    existiertNoch = existiertTutor?(student['SNr'], vorlesung['VNr'])
    assert(!existiertNoch, @fehler['nochTutor'])
  ensure
    tutorEntfernen(vorlesung['VNr'], student['SNr']) unless !existiertNoch
  end
end
