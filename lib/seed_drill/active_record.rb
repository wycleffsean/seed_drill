module SeedDrill
  class ActiveRecord < Adapter
    attr_reader :model

    def self.target_name
      'ActiveRecord::Base'
    end

    def initialize(relation)
      @rel = relation
      @klass = relation.klass
    end

    def first_or_create(fields)
      @rel.where(fields).first || @rel.create(fields)
    end

    def update_attributes(model, fields)
      model.update_attributes(fields)
    end

    def update_associations(model, fields)
      fields.each do |field, block|
        fail 'unknown association' unless associations.keys.map(&:to_sym).include?(field)
        klass = association_class(field)
        child_model = Sower.new(klass, &block).model
        model.send("#{field}=", child_model)
      end
    end

    private

    def associations
      @klass.reflections
    end

    def association_class(field)
        Kernel.const_get(associations[field.to_s].options[:class_name])
    end
  end
end
