require 'rubygems'
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
end
