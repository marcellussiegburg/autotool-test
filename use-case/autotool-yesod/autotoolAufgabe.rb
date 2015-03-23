# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolAufgabe < AutotoolAccount
  def aufgabeAnlegenGui(vorlesung, semester, name, hinweis)
    existiert = existiertAufgabe?(vorlesung['VNr'], name, hinweis)
    assert(!existiert, @fehler['vorAufgabe'])
    server = "http://kernkraft.imn.htwk-leipzig.de/cgi-bin/autotool-latest.cgi"
    typ = "Reconstruct-Direct"
    highscore = "Hoch"
    status = "Demonstration"
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    config = "[ ( Pre
  , [ e , j , b , i , f , m , l
    , k , d , g , c , a , h ] )
, ( In
  , [ b , j , i , e , k , l , d
    , m , g , f , a , c , h ] ) ]"
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'] + '/aufgabe')
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div/form/div[1]/input").send_key server
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div/form/div[2]/button").click
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form/div[2]/div/ul/li[14]/label").click
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form/div[2]/div/ul/li[14]/ul/li[1]/label").click
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form/div[2]/div/ul/li[14]/ul/li[1]/ul/li[1]/label").click
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form/div[2]/div/ul/li[14]/ul/li[1]/ul/li[1]/ul/li[1]/label").click
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div/form/div[3]/button").click
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div[1]/div/form/div[3]/div/label[1]/div/input").click
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div[1]/div/form/div[4]/button").click
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div[1]/div[1]/div/form/div[5]/textarea").clear
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div[1]/div[1]/div/form/div[5]/textarea").send_key config
    @driver.find_element(:xpath, "/html/body/div/div/div[2]/div/div[1]/div[1]/div[1]/div/form/div[6]/button").click
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[5]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[5]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[6]/textarea").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[6]/textarea").send_key hinweis
    select_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[7]/select", highscore)
    select_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[8]/select", status)
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[9]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[9]/input").send_key anfang.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[10]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[10]/input").send_key anfang.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[11]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[11]/input").send_key ende.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[12]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[12]/input").send_key ende.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div/form/div[14]/button").click
    angelegt = existiertAufgabe?(vorlesung['VNr'], name, hinweis)
    assert(angelegt, @fehler['nachAufgabe'])
    angelegt
  ensure
    aufgabeEntfernen(vorlesung['VNr'], name, hinweis) unless !angelegt
  end

  def aufgabeBearbeitenGui(aufgabe, vorlesung, semester, name, hinweis)
    existiert = existiertAufgabe?(aufgabe['VNr'], aufgabe['Name'], aufgabe['Remark'])
    assert(existiert, @fehler['keineAufgabe'])
    existiertNeu = existiertAufgabe?(vorlesung['VNr'], name, hinweis)
    assert(!existiertNeu, @fehler['vorAufgabe'])
    highscore = "High"
    status = "Demo"
    anfang = Time.now
    ende = Time.now + (60 * 60 * 24 * 31)
    config = "[ ( Pre
  , [ e , j , b , i , f , m , l
    , k , d , g , c , a , h ] )
, ( In
  , [ b , j , i , e , k , l , d
    , m , g , f , a , c , h ] ) ]"
    @driver.get(@config['url-yesod'] + '/aufgabe/' + aufgabe['ANr'])
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/ul/li[4]/a").click
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[2]/form/div[5]/textarea").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[2]/form/div[5]/textarea").send_key config
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[2]/form/div[6]/button").click
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/ul/li[3]/a").click
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[5]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[5]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[6]/textarea").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[6]/textarea").send_key hinweis
    select_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[7]/select", highscore)
    select_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[8]/select", status)
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[9]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[9]/input").send_key anfang.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[10]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[10]/input").send_key anfang.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[11]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[11]/input").send_key ende.strftime('%Y-%m-%d')
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[12]/input").clear
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[12]/input").send_key ende.strftime('%H:%M:%S')
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[14]/button").click
    existiertNeu2 = existiertAufgabe?(vorlesung['VNr'], name, hinweis)
    assert(existiertNeu2, @fehler['keineAufgabe'])
    assert_equal(aufgabe['GNr'], getAufgabe(vorlesung['VNr'], name, hinweis)['GNr'], @fehler['nichtBearbeitetAufgabe'])
  ensure
    aufgabeEntfernen(vorlesung['VNr'], name, hinweis) unless !existiertNeu2
  end

  def aufgabeEntfernenGui(aufgabe, vorlesung, semester)
    existiert = existiertAufgabe?(aufgabe['VNr'], aufgabe['Name'], aufgabe['Remark'])
    assert(existiert, @fehler['keineAufgabe'])
    @driver.get(@config['url-yesod'] + '/aufgabe/' + aufgabe['ANr'])
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/ul/li[3]/a").click
    @driver.find_element(:xpath, "/html/body/div[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/div[2]/form/div[15]/button").click
    existiertNoch = existiertAufgabe?(aufgabe['VNr'], aufgabe['Name'], aufgabe['Remark'])
    assert(!existiertNoch, @fehler['nochAufgabe'])
  end
end
