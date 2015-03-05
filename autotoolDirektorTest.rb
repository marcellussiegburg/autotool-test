require 'rubygems'
require_relative 'autotoolDirektor'

class AutotoolSchuleTest < AutotoolDirektor
  parallelize_me!()

  def test_direktorAnlegen
    direktorAnlegen = ->(schule, student) {
      ensureAdmin(schule['Name'], student, ->() {direktorErnennen(schule, student)})
    }
    mitSchuleAccount(direktorAnlegen)
  end

  def test_direktorAbsetzen
    direktorAbsetzen = ->(schule, student) {
      direktorAnlegen(student['SNr'], schule['UNr'])
      ensureAdmin(schule['Name'], student, ->() {direktorAbsetzen(schule, student)})
    }
    mitSchuleAccount(direktorAbsetzen)
  end
end
