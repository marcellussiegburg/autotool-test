require 'rubygems'
require_relative 'autotoolEinsendung'

class AutotoolEinsendungTest < AutotoolEinsendung
  parallelize_me!

  def test_aufgabeLoesen
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitAufgabe vorlesung['VNr'], ->(aufgabe) {
            mitGruppe vorlesung['VNr'], ->(gruppe) {
              mitEinschreibung student['SNr'], gruppe['GNr'], ->() {
                ensureEingeloggt schule['Name'], student['MNr'], ->() {
                  aufgabeLoesenGui(vorlesung, semester, aufgabe, student)
                }
              }
            }
          }
        }
      }
    }
  end

  def test_vorherigeEinsendung
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitAufgabe vorlesung['VNr'], ->(aufgabe) {
            mitGruppe vorlesung['VNr'], ->(gruppe) {
              mitEinschreibung student['SNr'], gruppe['GNr'], ->() {
                mitEinsendung student, vorlesung['VNr'], aufgabe['ANr'], ->(einsendung) {
                  ensureEingeloggt schule['Name'], student['MNr'], ->() {
                    vorherigeEinsendungGui(vorlesung, semester, aufgabe, student, einsendung)
                  }
                }
              }
            }
          }
        }
      }
    }
  end

  def test_aufgabeTesten
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitAufgabe vorlesung['VNr'], ->(aufgabe) {
            aufgabeAlsAbgelaufen(aufgabe)
            mitGruppe vorlesung['VNr'], ->(gruppe) {
              mitEinschreibung student['SNr'], gruppe['GNr'], ->() {
                ensureEingeloggt schule['Name'], student['MNr'], ->() {
                  aufgabeTestenGui(vorlesung, semester, aufgabe, student)
                }
              }
            }
          }
        }
      }
    }
  end
end
