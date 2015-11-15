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
      )
    SQL
  end

  def klass
    @klass ||= Class.new(ActiveRecord::Base).tap do |k|
      k.instance_eval do
        self.table_name = 'users'
      end
    end
  end
end
