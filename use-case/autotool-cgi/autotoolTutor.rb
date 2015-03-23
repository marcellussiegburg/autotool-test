# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolTutor < AutotoolAccount
  def tutorErnennen(vorlesung, semester, schule, student)
    existiert = existiertTutor?(student['SNr'], vorlesung['VNr'])
    assert(!existiert, @fehler['vorTutor'])
    @driver.find_element(:xpath, "/html/body/form/table[3]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input", schule['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", semester['Name'])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[2]/select", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[3]/input").click
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr/td[2]/input[2]").click
    select_element(:xpath, "/html/body/form/table[11]/tbody/tr/td[2]/select", student['MNr'] + ' ' + student['Vorname'] + ' ' + student['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[11]/tbody/tr/td[3]/input").click
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    angelegt = existiertTutor?(student['SNr'], vorlesung['VNr'])
    assert(angelegt, @fehler['nachTutor'])
  ensure
    tutorEntfernen(vorlesung['VNr'], student['SNr']) unless !angelegt
  end

  def tutorAbsetzen(vorlesung, semester, schule, student)
    existiert = existiertTutor?(student['SNr'], vorlesung['VNr'])
    assert(existiert, @fehler['keinTutor'])
    @driver.find_element(:xpath, "/html/body/form/table[3]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input", schule['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", semester['Name'])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[2]/select", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[3]/input").click
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr/td[2]/input[3]").click
    select_element(:xpath, "/html/body/form/table[11]/tbody/tr/td[2]/select", student['MNr'] + ' ' + student['Vorname'] + ' ' + student['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[11]/tbody/tr/td[3]/input").click
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existiertNoch = existiertTutor?(student['SNr'], vorlesung['VNr'])
    assert(!existiertNoch, @fehler['nochTutor'])
  ensure
    tutorEntfernen(vorlesung['VNr'], student['SNr']) unless !existiertNoch
  end
end
