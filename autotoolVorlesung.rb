# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolVorlesung < AutotoolAccount
  def vorlesungAnlegenGui(semester, schule, name, motd)
    existiert = existiertSemester?(semester['ENr'], name, schule['UNr'], motd)
    assert(!existiert, @fehler['vorVorlesung'])
    @driver.find_element(:xpath, "/html/body/form/table[3]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input", schule['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[3]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", semester['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]").send_key name
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/select", semester['Name'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/select[1]", anfang.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/select[2]", monate[anfang.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/select[3]", anfang.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/select[4]", anfang.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/select[5]", anfang.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/select[6]", anfang.strftime('%S'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[5]/td[2]/select[1]", ende.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[5]/td[2]/select[2]", monate[ende.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[5]/td[2]/select[3]", ende.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[5]/td[2]/select[4]", ende.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[5]/td[2]/select[5]", ende.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[5]/td[2]/select[6]", ende.strftime('%S'))
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[6]/td[2]").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[6]/td[2]").send_key motd
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    angelegt = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(angelegt, @fehler['nachVorlesung'])
    angelegt
  ensure
    vorlesungEntfernen(semester['ENr'], name, schule['UNr'], motd) unless !angelegt
  end
end
