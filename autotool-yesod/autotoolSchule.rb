require_relative 'autotoolAccount'

class AutotoolSchule < AutotoolAccount
  def schuleAnlegenGui(name, suffix)
    existiert = existiertSchule?(name)
    assert(!existiert, @fehler['vorSchule'])
    @driver.get(@config['url-yesod'] + '/schule')
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/input").send_keys name
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/input").send_keys suffix
    select_element(:xpath, "/html/body/div/div/form/div[3]/select", 'Deutsch')
    @driver.find_element(:xpath, "/html/body/div/div/form/div[4]/button").click
    angelegt = existiertSchule?(name)
    assert(angelegt, @fehler['nachSchule'])
    angelegt
  ensure
    schuleEntfernen(name) unless !angelegt
  end

  def schuleBearbeiten(schule, name, suffix)
    existiert = existiertSchule?(schule['Name'])
    assert(existiert, @fehler['keineSchule'])
    existiertNeu = existiertSchule?(name)
    assert(!existiertNeu, @fehler['vorSchule'])
    @driver.get(@config['url-yesod'] + '/schule/' + schule['UNr'])
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[1]/input").send_keys name
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/input").clear
    @driver.find_element(:xpath, "/html/body/div/div/form/div[2]/input").send_keys suffix
    select_element(:xpath, "/html/body/div/div/form/div[3]/select", 'Deutsch')
    @driver.find_element(:xpath, "/html/body/div/div/form/div[4]/button").click
    existiertNeu2 = existiertSchule?(name)
    assert(existiertNeu2, @fehler['keineSchule'])
    assert_equal(schule['UNr'], getSchule(name)['UNr'], @fehler['nichtBearbeitetSchule'])
  end
end
