require 'rubygems'
require_relative 'autotoolSemester'

class AutotoolSemesterTest < AutotoolSemester
  parallelize_me!()

  def test_semesterAnlegen
    name = testWort
    semesterAnlegen = ->(schule, student) {
      ensureDirektor(schule, student, ->() {semesterAnlegenGui(schule, name)})
    }
    mitSchuleAccount(semesterAnlegen)
  end

  def test_semesterBearbeiten
    name = testWort
    nameNeu = testWort
    semesterBearbeiten = ->(schule, student) {
      bearbeiten = ->() {
        semesterAnlegen(schule['UNr'], name)
        semesterBearbeitenGui(schule, getSemester(schule['UNr'], name), nameNeu)
      }
      ensureDirektor(schule, student, bearbeiten)
    }
    mitSchuleAccount(semesterBearbeiten)
  end
end
