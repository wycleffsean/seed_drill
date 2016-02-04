module SeedDrill
  class Adapter
    def self.get(klass)
      relation = klass.where(nil)
      key = (targets & relation.ancestors.map(&:to_s)).first
      adapter = adapters[key]
      adapter.new(relation)
    end

    def self.adapters
      Hash[descendants.map{|klass| [klass.target_name, klass] }]
    end

    private

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def self.targets
      adapters.keys
    end
  end
end
