# -*- coding: utf-8 -*-
require_relative 'autotoolAccount'

class AutotoolGruppe < AutotoolAccount
  def gruppeAnlegenGui(vorlesung, semester, name, maxStudenten, referent)
    existiert = existiertGruppe?(vorlesung['VNr'], name, maxStudenten, referent)
    assert(!existiert, @fehler['vorGruppe'])
    @driver.get(@config['url-yesod'] + '/vorlesung/' + vorlesung['VNr'] + '/gruppe')
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/input").send_key maxStudenten
    @driver.find_element(:xpath, "/html/body/div/div/form/div[3]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[3]/input").send_key referent
    @driver.find_element(:xpath, "/html/body/div/div/form/div[4]/button").click
    angelegt = existiertGruppe?(vorlesung['VNr'], name, maxStudenten, referent)
    assert(angelegt, @fehler['nachGruppe'])
    angelegt
  ensure
    gruppeEntfernen(vorlesung['VNr'], name, maxStudenten, referent) unless !angelegt
  end

  def gruppeBearbeitenGui(gruppe, vorlesung, semester, name, maxStudenten, referent)
    existiert = existiertGruppe?(gruppe['VNr'], gruppe['Name'], gruppe['MaxStudents'], gruppe['Referent'])
    assert(existiert, @fehler['keineGruppe'])
    existiertNeu = existiertGruppe?(vorlesung['VNr'], name, maxStudenten, referent)
    assert(!existiertNeu, @fehler['vorGruppe'])
    @driver.get(@config['url-yesod'] + '/gruppe/' + gruppe['GNr'])
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/input").send_key name
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/input").send_key maxStudenten
    @driver.find_element(:xpath, "/html/body/div/div/form/div[3]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[3]/input").send_key referent
    @driver.find_element(:xpath, "/html/body/div/div/form/div[4]/button").click
    existiertNeu2 = existiertGruppe?(vorlesung['VNr'], name, maxStudenten, referent)
    assert(existiertNeu2, @fehler['keineGruppe'])
    assert_equal(gruppe['GNr'], getGruppe(vorlesung['VNr'], name, maxStudenten, referent)['GNr'], @fehler['nichtBearbeitetGruppe'])
  ensure
    gruppeEntfernen(vorlesung['VNr'], name, maxStudenten, referent) unless !existiertNeu2
  end

  def gruppeEntfernenGui(gruppe, vorlesung, semester)
    existiert = existiertGruppe?(gruppe['VNr'], gruppe['Name'], gruppe['MaxStudents'], gruppe['Referent'])
    assert(existiert, @fehler['keineGruppe'])
    @driver.get(@config['url-yesod'] + '/gruppe/' + gruppe['GNr'])
    @driver.find_element(:xpath, "/html/body/div/div/form[2]/div[2]/button").click
    @driver.find_element(:xpath, "/html/body/div/div/form[2]/div[2]/button").click
    existiertNoch = existiertGruppe?(gruppe['VNr'], gruppe['Name'], gruppe['MaxStudents'], gruppe['Referent'])
    assert(!existiertNoch, @fehler['nochGruppe'])
  end
end
