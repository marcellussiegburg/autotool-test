require 'rubygems'
require_relative 'autotoolTutor'

class AutotoolTutorTest < AutotoolTutor
  parallelize_me!()

  def test_tutorErnennen
    name = testWort
    motd = testWort
    mitSchuleAccount(->(schule, student) {
      mitSemester(schule['UNr'], ->(semester) {
        mitVorlesung(semester['ENr'], schule['UNr'], ->(vorlesung) {
          ensureDirektor(schule, student, ->() {
            tutorErnennen(vorlesung, semester, schule, student)
          })
        })
      })
    })
  end

  def test_tutorAbsetzen
    name = testWort
    motd = testWort
    mitSchuleAccount(->(schule, student) {
      mitSemester(schule['UNr'], ->(semester) {
        mitVorlesung(semester['ENr'], schule['UNr'], ->(vorlesung) {
          tutorAnlegen(student['SNr'], vorlesung['VNr'])
          ensureDirektor(schule, student, ->() {
            tutorAbsetzen(vorlesung, semester, schule, student)
          })
        })
      })
    })
  end
end
