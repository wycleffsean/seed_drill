require 'test_helper'
require 'active_record'

class ActiveRecordTest < MiniTest::Test
  include SharedExamples

  def setup
    configs = YAML.load_file('test/database.yml')
    ActiveRecord::Base.configurations = configs
    db_name = ENV['DB'] || 'sqlite'
    ActiveRecord::Base.establish_connection(db_name.to_sym)
    ActiveRecord::Base.default_timezone = :utc
    migrate
  end

  private

  def migrate
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE TABLE IF NOT EXISTS users
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email CHARACTER VARYING(255),
        name CHARACTER VARYING(255)
      );
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
      CREATE TABLE IF NOT EXISTS comments
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        body CHARACTER VARYING(255)
      );
    SQL
  end

  class User < ActiveRecord::Base
    has_many :comments, class_name: 'ActiveRecordTest::Comment'
  end

  class Comment < ActiveRecord::Base
    belongs_to :user, class_name: 'ActiveRecordTest::User'
  end
end
