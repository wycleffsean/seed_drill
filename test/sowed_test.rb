require 'test_helper'

class TestSow < MiniTest::Test
  def test_has_a_version_number
    refute_nil SeedDrill::VERSION
  end
end
