require 'rubygems'
require_relative 'autotoolGruppe'

class AutotoolGruppeTest < AutotoolGruppe
  parallelize_me!()

  def test_gruppeAnlegen
    name = testWort
    referent = testWort
    maxStudenten = (5 + rand(50)).to_s
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          ensureTutor schule, vorlesung, student, ->() {
            gruppeAnlegenGui(vorlesung, semester, name, maxStudenten, referent)
          }
        }
      }
    }
  end

  def test_gruppeBearbeiten
    name = testWort
    referent = testWort
    maxStudenten = (5 + rand(50)).to_s
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitGruppe vorlesung['VNr'], ->(gruppe) {
            ensureTutor schule, vorlesung, student, ->() {
              gruppeBearbeitenGui(gruppe, vorlesung, semester, name, maxStudenten, referent)
            }
          }
        }
      }
    }
  end

  def test_gruppeEntfernen
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitGruppe vorlesung['VNr'], ->(gruppe) {
            ensureTutor schule, vorlesung, student, ->() {
              gruppeEntfernenGui(gruppe, vorlesung, semester)
            }
          }
        }
      }
    }
  end
end
