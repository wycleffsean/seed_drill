module SharedExamples
  def teardown
    user_class.delete_all
  end

  def user_class
    self.class::User
  end

  def comment_class
    self.class::Comment
  end

  def fields
    {
      email: 'guy@example.com',
      name: 'John Doe',
    }
  end

  def test_create_returns_object
    refute_nil Sow.ensure(user_class, fields)
  end

  def test_creates_new_record
    Sow.ensure(user_class, fields)

    assert_equal 1, user_class.count
  end

  def test_alters_existing_record
    user_class.create(fields)
    Sow.ensure(user_class, email: fields[:email]) do
      name 'Bryan Adams'
    end

    assert_equal 1, user_class.count
    assert_equal 'Bryan Adams', user_class.first.name
  end

  def test_creates_belongs_to_association
    comment = Sow.ensure(comment_class, body: 'abc') do
      user do
        email 'guy@example.com'
      end
    end

    refute_nil comment.user
  end
end
