require_relative 'autotoolAccount'

class AutotoolSchule < AutotoolAccount
  def schuleAnlegenGui(name, suffix)
    existiert = existiertSchule?(name)
    assert(!existiert, @fehler['vorSchule'])
    @driver.find_element(:id, @ui['administratorButton']).click
    @driver.find_element(:id, @ui['schuleAnlegenButton']).click
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr[1]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr[1]/td[2]/input").send_keys name
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr[2]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr[2]/td[2]/input").send_keys suffix
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    angelegt = existiertSchule?(name)
    assert(angelegt, @fehler['nachSchule'])
    angelegt
  end

  def schuleBearbeiten(schule, name, suffix)
    existiert = existiertSchule?(schule['Name'])
    assert(existiert, @fehler['keineSchule'])
    existiertNeu = existiertSchule?(name)
    assert(!existiertNeu, @fehler['vorSchule'])
    @driver.find_element(:id, @ui['administratorButton']).click
    schulen = @driver.find_elements(:xpath, "/html/body/form/table[4]/tbody/tr/td[2]/input")
    index = schulen.map{|s| s.attribute('value')}.index(schule['Name'])
    assert(!!index, @fehler['keineSchule'])
    schulen[index].click
    @driver.find_element(:xpath, "/html/body/form/table[5]/tbody/tr/td[2]/input[1]").click
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr[1]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr[1]/td[2]/input").send_keys name
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr[2]/td[2]/input").clear
    @driver.find_element(:xpath, "/html/body/form/table[6]/tbody/tr[2]/td[2]/input").send_keys suffix
    @driver.find_elements(:xpath, "/html/body/form/input[@type='submit']")[2].click
    existertNeu2 = existiertSchule?(name)
    assert(existiertNeu2, @fehler['keineSchule'])
    assert_equal(schule['UNr'], getSchule(name)['UNr'], @fehler['nichtBearbeitetSchule'])
  end
end
