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

  def test_schuleBearbeiten
    name = testWort
    suffix = testWort
    schuleBearbeiten = ->(schule, student) {
      ensureAdmin(schule['Name'], student, ->() {schuleBearbeiten(schule, name, suffix)})
    }
    mitSchuleAccount(schuleBearbeiten)
  end
end
