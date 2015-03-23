# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolVorlesung < AutotoolAccount
  def vorlesungAnlegenGui(semester, schule, name, motd)
    existiert = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(!existiert, @fehler['vorVorlesung'])
    @driver.find_element(:xpath, "/html/body/form/table[3]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input", schule['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[3]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", semester['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/input").send_key name
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
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[6]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[6]/td[2]/input").send_key motd
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    angelegt = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(angelegt, @fehler['nachVorlesung'])
    angelegt
  ensure
    vorlesungEntfernen(semester['ENr'], name, schule['UNr'], motd) unless !angelegt
  end

  def vorlesungBearbeitenGui(vorlesung, semester, schule, name, motd)
    existiert = existiertVorlesung?(vorlesung['ENr'], vorlesung['Name'], vorlesung['unr'], vorlesung['motd'])
    assert(existiert, @fehler['keineVorlesung'])
    existiertNeu = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(!existiertNeu, @fehler['vorVorlesung'])
    @driver.find_element(:xpath, "/html/body/form/table[3]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input", schule['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", semester['Name'])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[2]/select", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[3]/input").click
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[2]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[2]/td[2]/input").send_key name
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[3]/td[2]/select", semester['Name'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[4]/td[2]/select[1]", anfang.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[4]/td[2]/select[2]", monate[anfang.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[4]/td[2]/select[3]", anfang.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[4]/td[2]/select[4]", anfang.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[4]/td[2]/select[5]", anfang.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[4]/td[2]/select[6]", anfang.strftime('%S'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[5]/td[2]/select[1]", ende.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[5]/td[2]/select[2]", monate[ende.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[5]/td[2]/select[3]", ende.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[5]/td[2]/select[4]", ende.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[5]/td[2]/select[5]", ende.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[10]/tbody/tr[5]/td[2]/select[6]", ende.strftime('%S'))
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[6]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[10]/tbody/tr[6]/td[2]/input").send_key motd
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existiertNeu2 = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(existiertNeu2, @fehler['keineVorlesung'])
    assert_equal(vorlesung['VNr'], getVorlesung(semester['ENr'], name, schule['UNr'], motd)['VNr'], @fehler['nichtBearbeitetVorlesung'])
  ensure
    vorlesungEntfernen(semester['ENr'], name, schule['UNr'], motd) unless !existiertNeu2
  end

  def vorlesungBearbeitenTutorGui(vorlesung, semester, schule, name, motd)
    existiert = existiertVorlesung?(vorlesung['ENr'], vorlesung['Name'], vorlesung['unr'], vorlesung['motd'])
    assert(existiert, @fehler['keineVorlesung'])
    existiertNeu = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(!existiertNeu, @fehler['vorVorlesung'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/input").send_key name
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[3]/td[2]/select", semester['Name'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[4]/td[2]/select[1]", anfang.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[4]/td[2]/select[2]", monate[anfang.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[4]/td[2]/select[3]", anfang.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[4]/td[2]/select[4]", anfang.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[4]/td[2]/select[5]", anfang.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[4]/td[2]/select[6]", anfang.strftime('%S'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[5]/td[2]/select[1]", ende.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[5]/td[2]/select[2]", monate[ende.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[5]/td[2]/select[3]", ende.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[5]/td[2]/select[4]", ende.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[5]/td[2]/select[5]", ende.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[7]/tbody/tr[5]/td[2]/select[6]", ende.strftime('%S'))
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[6]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[6]/td[2]/input").send_key motd
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existiertNeu2 = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(existiertNeu2, @fehler['keineVorlesung'])
    assert_equal(vorlesung['VNr'], getVorlesung(semester['ENr'], name, schule['UNr'], motd)['VNr'], @fehler['nichtBearbeitetVorlesung'])
  ensure
    vorlesungEntfernen(semester['ENr'], name, schule['UNr'], motd) unless !existiertNeu2
  end

  def vorlesungEntfernenGui(vorlesung, semester, schule)
    existiert = existiertVorlesung?(vorlesung['ENr'], vorlesung['Name'], vorlesung['unr'], vorlesung['motd'])
    assert(existiert, @fehler['keineVorlesung'])
    @driver.find_element(:xpath, "/html/body/form/table[3]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input", schule['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[2]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", semester['Name'])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[2]/select", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr/td[3]/input").click
    @driver.find_element(:xpath, "/html/body/form/table[9]/tbody/tr/td[2]/input[3]").click
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existiertNoch = existiertVorlesung?(vorlesung['ENr'], vorlesung['Name'], vorlesung['unr'], vorlesung['motd'])
    assert(!existiertNoch, @fehler['nochVorlesung'])
  end
end
