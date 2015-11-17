require 'test_helper'

class UtilsTest < MiniTest::Test
  def setup
    @fields = Sow::Fields.new(d: true) do |fixed|
      fixed.a true
      b true
      c do
      end
    end
  end

  def test_gets_fixed_fields
    assert_equal true, @fields.fixed[:a]
  end

  def test_fields_in_constructor
    assert_equal true, @fields.fixed[:d]
  end

  def test_gets_variant_fields
    assert_equal true, @fields.variant[:b]
  end

  def test_gets_associate_fields
    assert_instance_of Proc, @fields.proc[:c]
  end
end
