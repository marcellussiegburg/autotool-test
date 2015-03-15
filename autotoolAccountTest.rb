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
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        login(schule['Name'], student['MNr'])
      }
    }
  end

  def test_logout
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        login(schule['Name'], student['MNr'])
        logout()
      }
    }
  end
end
