# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolEinsendung < AutotoolAccount
  def aufgabeLoesenGui(vorlesung, semester, aufgabe, student)
    existiert = existiertEinsendung?(student['SNr'], aufgabe['ANr'])
    assert(!existiert, @fehler['vorEinsendung'])
    einsendung = "e (j (b, i), (f (m (l (k, d), g), c (a, h))))"
    @driver.get(@config['url-yesod'] + '/aufgabe/' + aufgabe['ANr'] + '/einsendung')
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form[2]/div[2]/textarea").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form[2]/div[2]/textarea").send_key einsendung
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form[2]/div[3]/button").click
    angelegt = existiertEinsendung?(student['SNr'], aufgabe['ANr'])
    assert(angelegt, @fehler['nachEinsendung'])
    angelegt
  ensure
    einsendungEntfernen(student, vorlesung['VNr'], aufgabe['ANr']) unless !angelegt
  end

  def vorherigeEinsendungGui(vorlesung, semester, aufgabe, student, einsendung)
    existiert = existiertEinsendung?(einsendung['SNr'], einsendung['ANr'])
    assert(existiert, @fehler['keineEinsendung'])
    @driver.get(@config['url-yesod'] + '/einsendung/' + aufgabe['ANr'] + '/' + student['SNr'])
    angezeigt = @driver.find_element(:xpath, "/html/body/div/div").attribute('innerHTML').include?(readFile(einsendung['Report']))
    assert(angezeigt, @fehler['keineEinsendung'])
  end

  def aufgabeTestenGui(vorlesung, semester, aufgabe, student)
    existiert = existiertEinsendung?(student['SNr'], aufgabe['ANr'])
    assert(!existiert, @fehler['vorEinsendung'])
    einsendung = "e (j (b, i), (f (m (l (k, d), g), c (a, h))))"
    @driver.get(@config['url-yesod'] + '/server/http:%2F%2Fkernkraft.imn.htwk-leipzig.de%2Fcgi-bin%2Fautotool-latest.cgi/aufgabe/Reconstruct-Direct/konfiguration/%5B%28Pre%0D%0A,%5Be,j,b,i,f,m,l%0D%0A,k,d,g,c,a,h%5D%29%0D%0A,%28In%0D%0A,%5Bb,j,i,e,k,l,d%0D%0A,m,g,f,a,c,h%5D%29%5D/id/1234')
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form/div[2]/textarea").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form/div[2]/textarea").send_key einsendung
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form/div[3]/button").click
    angezeigt = @driver.find_element(:xpath, "/html/body/div/div").attribute('innerHTML').include?(readFile('../latest.report-yesod'))
    angelegt = existiertEinsendung?(student['SNr'], aufgabe['ANr'])
    assert(!angelegt, @fehler['keinTestEinsendung'])
    angelegt
  ensure
    einsendungEntfernen(student, vorlesung['VNr'], aufgabe['ANr']) unless !angelegt
  end
end
