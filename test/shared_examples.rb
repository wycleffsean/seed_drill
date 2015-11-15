module SharedExamples
  def teardown
    klass.delete_all
  end

  def fields
    {
      email: 'guy@example.com',
      name: 'John Doe',
    }
  end

  def test_create_returns_object
    refute_nil Sow.create(klass, fields)
  end

  def test_creates_new_record
    Sow.create(klass, fields)

    assert_equal 1, klass.count
  end

  def test_alters_existing_record
    klass.create(fields)
    Sow.create(klass, email: fields[:email]) do
      name 'Bryan Adams'
    end

    assert_equal 1, klass.count
    assert_equal 'Bryan Adams', klass.first.name
  end
end
