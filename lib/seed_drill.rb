require "seed_drill/version"
require "seed_drill/utils"
require "seed_drill/adapter"
require "seed_drill/active_record"

module SeedDrill
  ###
  # Sow.ensure(User) do |fixed|
  #   fixed.email     'guy@something.com'
  #   zip_code        28205
  #   state_province  :NC
  # end
  ###
  def self.sow(relation_or_klass, fixed_fields = nil, &block)
    Sower.new(relation_or_klass, &block).model
  end

  class Sower # :nodoc:
    attr_reader :model

    def initialize(klass, fixed_fields = nil, &block)
      fields = Fields.new(fixed_fields, &block)
      adapter = Adapter.get(klass)
      @model = adapter.first_or_create(fields.fixed)
      adapter.update_attributes(model, fields.variant)
      adapter.update_associations(model, fields.proc)
      model.save
    end
  end
end

