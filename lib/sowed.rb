require "sowed/version"

class Sow
  attr_reader :model

  def self.create(relation, fixed_fields = {}, &block)
    new(relation, fixed_fields, &block).model
  end

  def initialize(relation, fixed_fields = {}, &block)
    @rel = relation.where(nil)
    @klass = @rel.klass
    @model = first_or_create(fixed_fields)
    instance_eval(&block) unless block.nil?
    @model.save
  end

  def method_missing(method_name, *args, &block)
    case method_name
    when *attributes
      @model.send("#{method_name}=", *args, &block)
    when *associations.keys.map(&:to_sym)
      model = self.class.new(association_class(method_name), *args, &block).model
      @model.send("#{method_name}=", model)
    else
      super
    end
  end

  private

  def first_or_create(rel = @rel, fields)
    @rel.where(fields).first || @rel.create(fields)
  end

  def attributes
    case
      when @rel.class.ancestors.include?(Enumerable)
        @rel.klass.new.attributes.keys.map(&:to_sym)
      else
        @rel.new.attributes.keys.map(&:to_sym)
    end
  end

  def associations
    case
      when @klass.ancestors.include?(ActiveRecord::Base)
        @klass.reflections
      when @klass.ancestors.include?(Mongoid::Relations)
        @klass.associations
      else
        raise TypeError.new('unsupported type')
    end
  end

  def association_class(field)
      Kernel.const_get(associations[field.to_s].options[:class_name])
  end
end
