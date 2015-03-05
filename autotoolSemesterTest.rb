require 'rubygems'
require_relative 'autotoolSemester'

class AutotoolSchuleTest < AutotoolSemester
  parallelize_me!()

  def test_semesterAnlegen
    name = testWort
    semesterAnlegen = ->(schule, student) {
      ensureDirektor(schule, student, ->() {semesterAnlegenGui(schule, name)})
    }
    mitSchuleAccount(semesterAnlegen)
  end
end
