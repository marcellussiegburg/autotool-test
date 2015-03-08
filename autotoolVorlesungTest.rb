require 'rubygems'
require_relative 'autotoolVorlesung'

class AutotoolVorlesungTest < AutotoolVorlesung
  parallelize_me!()

  def test_vorlesungAnlegen
    name = testWort
    motd = testWort
    vorlesungAnlegen = ->(schule, student) {
      mitSemester(schule['UNr'], ->(semester) {
        ensureDirektor(schule, student, ->() {
          vorlesungAnlegenGui(semester, schule, name, motd)
        })
      })
    }
    mitSchuleAccount(vorlesungAnlegen)
  end

  def test_vorlesungBearbeiten
    name = testWort
    motd = testWort
    mitSchuleAccount(->(schule, student) {
      mitSemester(schule['UNr'], ->(semester) {
        mitVorlesung(semester['ENr'], schule['UNr'], ->(vorlesung) {
          ensureDirektor(schule, student, ->() {
            vorlesungBearbeitenGui(vorlesung, semester, schule, name, motd)
          })
        })
      })
    })
  end

  def test_vorlesungEntfernen
    name = testWort
    motd = testWort
    mitSchuleAccount(->(schule, student) {
      mitSemester(schule['UNr'], ->(semester) {
        mitVorlesung(semester['ENr'], schule['UNr'], ->(vorlesung) {
          ensureDirektor(schule, student, ->() {
            vorlesungEntfernenGui(vorlesung, semester, schule, name, motd)
          })
        })
      })
    })
  end
end
