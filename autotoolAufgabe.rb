# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolAufgabe < AutotoolAccount
  def aufgabeAnlegenGui(vorlesung, semester, name, hinweis)
    existiert = existiertAufgabe?(vorlesung['VNr'], name, hinweis)
    assert(!existiert, @fehler['vorAufgabe'])
    server = "http://kernkraft.imn.htwk-leipzig.de/cgi-bin/autotool-latest.cgi"
    typ = "Reconstruct-Direct"
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
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[1]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[1]/td[2]/input").send_key server
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[1]/td[3]/input").click
    click_element(:xpath, "/html/body/form/table[8]/tbody/tr[2]/td[2]/input", "Datenstrukturen")
    click_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/input", "Bäume")
    click_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/input", "Pre/In/Post/Level-Order")
    click_element(:xpath, "/html/body/form/table[8]/tbody/tr[5]/td[2]/input", typ)
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[6]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[6]/td[2]/input").send_key name
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[7]/td[2]/textarea").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[7]/td[2]/textarea").send_key hinweis
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[8]/td[2]/select", highscore)
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[9]/td[2]/select", status)
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/select[1]", anfang.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/select[2]", monate[anfang.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/select[3]", anfang.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/select[4]", anfang.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/select[5]", anfang.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/select[6]", anfang.strftime('%S'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[11]/td[2]/select[1]", ende.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[11]/td[2]/select[2]", monate[ende.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[11]/td[2]/select[3]", ende.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[11]/td[2]/select[4]", ende.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[11]/td[2]/select[5]", ende.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[11]/td[2]/select[6]", ende.strftime('%S'))
    click_element(:xpath, "/html/body/form/table[8]/tbody/tr[12]/td[2]/input", "(previous/default)")
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[13]/td[2]/table/tbody/tr[1]/td/textarea").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[13]/td[2]/table/tbody/tr[1]/td/textarea").send_key config
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[13]/td[2]/table/tbody/tr[3]/td/input").click
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
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
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[1]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", aufgabe['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/input[2]").click
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[3]/td[2]/input").send_key name
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/textarea").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[4]/td[2]/textarea").send_key hinweis
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[5]/td[2]/select", highscore)
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[6]/td[2]/select", status)
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[7]/td[2]/select[1]", anfang.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[7]/td[2]/select[2]", monate[anfang.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[7]/td[2]/select[3]", anfang.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[7]/td[2]/select[4]", anfang.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[7]/td[2]/select[5]", anfang.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[7]/td[2]/select[6]", anfang.strftime('%S'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[8]/td[2]/select[1]", ende.strftime('%Y'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[8]/td[2]/select[2]", monate[ende.strftime('%m')])
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[8]/td[2]/select[3]", ende.strftime('%d'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[8]/td[2]/select[4]", ende.strftime('%H'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[8]/td[2]/select[5]", ende.strftime('%M'))
    select_element(:xpath, "/html/body/form/table[8]/tbody/tr[8]/td[2]/select[6]", ende.strftime('%S'))
    click_element(:xpath, "/html/body/form/table[8]/tbody/tr[9]/td[2]/input", "(previous/default)")
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/table/tbody/tr[1]/td/textarea").clear
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/table/tbody/tr[1]/td/textarea").send_key config
    @driver.find_element(:xpath, "/html/body/form/table[8]/tbody/tr[10]/td[2]/table/tbody/tr[3]/td/input").click
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existiertNeu2 = existiertAufgabe?(vorlesung['VNr'], name, hinweis)
    assert(existiertNeu2, @fehler['keineAufgabe'])
    assert_equal(aufgabe['GNr'], getAufgabe(vorlesung['VNr'], name, hinweis)['GNr'], @fehler['nichtBearbeitetAufgabe'])
  ensure
    aufgabeEntfernen(vorlesung['VNr'], name, hinweis) unless !existiertNeu2
  end

  def aufgabeEntfernenGui(aufgabe, vorlesung, semester)
    existiert = existiertAufgabe?(aufgabe['VNr'], aufgabe['Name'], aufgabe['Remark'])
    assert(existiert, @fehler['keineAufgabe'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[1]/td[2]/input", semester['Name'])
    click_element(:xpath, "/html/body/form/table[3]/tbody/tr[2]/td[2]/input", vorlesung['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr/td[2]/input[1]").click
    click_element(:xpath, "/html/body/form/table[7]/tbody/tr/td[2]/input", aufgabe['Name'])
    @driver.find_element(:xpath, "/html/body/form/table[7]/tbody/tr[2]/td[2]/input[3]").click
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existiertNoch = existiertAufgabe?(aufgabe['VNr'], aufgabe['Name'], aufgabe['Remark'])
    assert(!existiertNoch, @fehler['nochAufgabe'])
  end
end
