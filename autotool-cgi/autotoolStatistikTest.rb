require 'rubygems'
require_relative 'autotoolStatistik'

class AutotoolStatistikTest < AutotoolStatistik
  parallelize_me!

  def test_einsendungBearbeiten
    einsendungText = testWort
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitAufgabe vorlesung['VNr'], ->(aufgabe) {
            mitGruppe vorlesung['VNr'], ->(gruppe) {
              mitEinschreibung student['SNr'], gruppe['GNr'], ->() {
                mitEinsendung student, vorlesung['VNr'], aufgabe['ANr'], ->(einsendung) {
                  ensureTutor schule, vorlesung, student, ->() {
                    einsendungBearbeitenGui(vorlesung, semester, aufgabe, student, einsendung, einsendungText)
                  }
                }
              }
            }
          }
        }
      }
    }
  end

  def test_cacheLeeren
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitAufgabe vorlesung['VNr'], ->(aufgabe) {
            mitGruppe vorlesung['VNr'], ->(gruppe) {
              mitEinschreibung student['SNr'], gruppe['GNr'], ->() {
                mitEinsendung student, vorlesung['VNr'], aufgabe['ANr'], ->(einsendung) {
                  mitCache vorlesung['VNr'], aufgabe['ANr'], student['MNr'], ->() {
                    ensureTutor schule, vorlesung, student, ->() {
                      cacheLeerenGui(vorlesung, semester, aufgabe, student)
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  end

  def test_aufgabeStatistik
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitAufgaben 10, vorlesung['VNr'], ->(aufgaben) {
            mitGruppe vorlesung['VNr'], ->(gruppe) {
              mitStudenten 10, schule['UNr'], ->(studenten) {
                mitEinschreibungen studenten.map { |s| s['SNr'] }, gruppe['GNr'], ->() {
                  mitEinsendungen studenten, vorlesung['VNr'], aufgaben.map { |a| a['ANr'] }, ->() {
                    ensureTutor schule, vorlesung, student, ->() {
                      aufgabeStatistikGui(vorlesung, semester, aufgaben, [student])
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  end
end
