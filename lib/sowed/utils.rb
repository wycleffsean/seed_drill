module Sow
  class Fields # :nodoc:
    attr_reader :fixed

    def initialize(args = nil, &block)
      fixed = Hasher.new
      variant = Hasher.new
      variant.instance_exec(fixed, &block) if block_given?
      @fixed = args || {}
      @fixed.merge!(fixed.hash || {})
      @variant = variant.hash || {}
    end

    def variant
      @variant.reject{|k,v| v.instance_of?(Proc) }
    end

    def proc
      @variant.select{|k,v| v.instance_of?(Proc) }
    end
  end

  private

  class Hasher # :nodoc:
    attr_reader :hash
    def method_missing(key, *value, &block)
      @hash ||= Hash.new
      @hash[key] = block || value.first
    end
  end
end
