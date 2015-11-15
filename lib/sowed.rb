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
      model = self.class.new(@model.send(method_name), *args, &block).model
      many_to_many(model, associations[method_name.to_s])
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

  def many_to_many(model, association)
    if association[:relation] == Mongoid::Relations::Referenced::ManyToMany
      list = @model.send(association[:name])
      list.push model unless list.include?(model)
    end
  end
end
