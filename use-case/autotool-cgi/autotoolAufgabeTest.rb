require 'rubygems'
require_relative 'autotoolAufgabe'

class AutotoolAufgabeTest < AutotoolAufgabe
  def test_aufgabeAnlegen
    name = testWort
    hinweis = testWort
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          ensureTutor schule, vorlesung, student, ->() {
            aufgabeAnlegenGui(vorlesung, semester, name, hinweis)
          }
        }
      }
    }
  end

  def test_aufgabeBearbeiten
    name = testWort
    hinweis = testWort
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitAufgabe vorlesung['VNr'], ->(aufgabe) {
            ensureTutor schule, vorlesung, student, ->() {
              aufgabeBearbeitenGui(aufgabe, vorlesung, semester, name, hinweis)
            }
          }
        }
      }
    }
  end

  def test_aufgabeEntfernen
    mitSchuleAccount ->(schule, student) {
      mitSemester schule['UNr'], ->(semester) {
        mitVorlesung semester['ENr'], schule['UNr'], ->(vorlesung) {
          mitAufgabe vorlesung['VNr'], ->(aufgabe) {
            ensureTutor schule, vorlesung, student, ->() {
              aufgabeEntfernenGui(aufgabe, vorlesung, semester)
            }
          }
        }
      }
    }
  end
end
