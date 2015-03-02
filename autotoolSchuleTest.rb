require 'rubygems'
require_relative 'autotoolSchule'

class AutotoolSchuleTest < AutotoolSchule
  parallelize_me!()

  def test_schuleAnlegen
    name = testWort
    suffix = testWort
    schuleAnlegen = ->(schule, student) {
      ensureAdmin(schule['Name'], student, ->() {schuleAnlegenGui(name, suffix)})
    }
    angelegt = mitSchuleAccount(schuleAnlegen)
  ensure
    schuleEntfernen(nameNeu) unless !angelegt
  end
end
