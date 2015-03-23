require 'rubygems'
require_relative 'autotoolEinschreibung'

class AutotoolEinschreibungTest < AutotoolEinschreibung
  parallelize_me!

  def test_einschreibungAnlegen
    name = testWort
    hinweis = testWort
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitGruppe vorlesung['VNr'], ->(gruppe) {
            ensureEingeloggt schule['Name'], student['MNr'], ->() {
              einschreibenGui(vorlesung, semester, gruppe, student)
            }
          }
        }
      }
    }
  end

  def test_einschreibungEntfernen
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitGruppe vorlesung['VNr'], ->(gruppe) {
            mitEinschreibung student['SNr'], gruppe['GNr'], ->() {
              ensureEingeloggt schule['Name'], student['MNr'], ->() {
                austragenGui(vorlesung, semester, gruppe, student)
              }
            }
          }
        }
      }
    }
  end
end
