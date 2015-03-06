# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolDirektor < AutotoolAccount
  def direktorErnennen(schule, student)
    existiert = existiertDirektor?(student['SNr'], schule['UNr'])
    assert(!existiert, @fehler['vorDirektor'])
    @driver.find_element(:id, @ui['administratorButton']).click
    schulen = @driver.find_elements(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input").find do |button|
      button.attribute('value') == schule['Name']
    end.click
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[1]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/select", student['MNr'] + ' ' + student['Vorname'] + ' ' + student['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[3]/input").click
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    angelegt = existiertDirektor?(student['SNr'], schule['UNr'])
    assert(angelegt, @fehler['nachDirektor'])
    angelegt
  ensure
    direktorEntfernen(student['SNr'], schule['UNr']) unless !angelegt
  end

  def direktorAbsetzen(schule, student)
    existiert = existiertDirektor?(student['SNr'], schule['UNr'])
    assert(existiert, @fehler['keinDirektor'])
    @driver.find_element(:id, @ui['administratorButton']).click
    schulen = @driver.find_elements(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input").find do |button|
      button.attribute('value') == schule['Name']
    end.click
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/select", student['MNr'] + ' ' + student['Vorname'] + ' ' + student['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[3]/input").click
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existiertNoch = existiertDirektor?(student['SNr'], schule['UNr'])
    assert(!existiertNoch, @fehler['nochDirektor'])
  ensure
      direktorEntfernen(student['SNr'], schule['UNr'])
  end
end
