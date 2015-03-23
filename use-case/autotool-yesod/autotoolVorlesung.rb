# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolVorlesung < AutotoolAccount
  def vorlesungAnlegenGui(semester, schule, name, motd)
    existiert = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(!existiert, @fehler['vorVorlesung'])
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    @driver.get(@config['url-yesod'] + '/semester/' + semester['ENr'] + '/vorlesung')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[1]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[2]/input").send_key anfang.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[3]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[3]/input").send_key anfang.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[4]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[4]/input").send_key ende.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[5]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[5]/input").send_key ende.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[6]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[6]/input").send_key motd
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[7]/button").click
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
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'])
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[1]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[2]/input").send_key anfang.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[3]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[3]/input").send_key anfang.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[4]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[4]/input").send_key ende.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[5]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[5]/input").send_key ende.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[6]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[6]/input").send_key motd
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[1]/div[7]/button").click
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
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'])
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[1]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[2]/input").send_key anfang.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[3]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[3]/input").send_key anfang.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[4]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[4]/input").send_key ende.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[5]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[5]/input").send_key ende.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[6]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[6]/input").send_key motd
    @driver.find_element(:xpath, "/html/body/div[1]/div/form/div[7]/button").click
    existiertNeu2 = existiertVorlesung?(semester['ENr'], name, schule['UNr'], motd)
    assert(existiertNeu2, @fehler['keineVorlesung'])
    assert_equal(vorlesung['VNr'], getVorlesung(semester['ENr'], name, schule['UNr'], motd)['VNr'], @fehler['nichtBearbeitetVorlesung'])
  ensure
    vorlesungEntfernen(semester['ENr'], name, schule['UNr'], motd) unless !existiertNeu2
  end

  def vorlesungEntfernenGui(vorlesung, semester, schule)
    existiert = existiertVorlesung?(vorlesung['ENr'], vorlesung['Name'], vorlesung['unr'], vorlesung['motd'])
    assert(existiert, @fehler['keineVorlesung'])
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'])
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[2]/div[2]/button").click
    @driver.find_element(:xpath, "/html/body/div[1]/div/form[2]/div[2]/button").click
    existiertNoch = existiertVorlesung?(vorlesung['ENr'], vorlesung['Name'], vorlesung['unr'], vorlesung['motd'])
    assert(!existiertNoch, @fehler['nochVorlesung'])
  end
end
