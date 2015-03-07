require 'rubygems'
require_relative 'autotoolVorlesung'

class AutotoolVorlesungTest < AutotoolVorlesung
  parallelize_me!()

  def test_vorlesungAnlegen
    name = testWort
    motd = testWort
    vorlesungAnlegen = ->(schule, student) {
      mitSemester(schule['UNr'], ->(semester) {
        ensureDirektor(schule, student, ->() {vorlesungAnlegenGui(semester, schule, name, motd)})
      })
    }
    mitSchuleAccount(vorlesungAnlegen)
  end
end
