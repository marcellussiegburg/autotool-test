require 'rubygems'
require_relative 'autotoolAccount'

class AutotoolAccountTest < AutotoolAccount
  parallelize_me!()

  def test_accountAnlegen
    mnr = testWort
    vorname = testWort
    name = testWort
    email = @config['email']
    angelegt = accountAnlegenGui(mnr, vorname, name, email)
  ensure
    accountEntfernen(mnr, vorname, name, email) unless !angelegt
  end

  def test_login
    login = ->(schule, student) {
      login(schule['Name'], student[:MNr])
    }
    mitSchuleAccount(login)
  end

  def test_logout
    logout = ->(schule, student) {
      login(schule['Name'], student[:MNr])
      logout()
    }
    mitSchuleAccount(logout)
  end
end
