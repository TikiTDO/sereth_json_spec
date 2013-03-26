module Sereth::JsonSpec
  module Extender
    # Generate the active path of this spec, for use with sub-specs
    def json_spec_path
      path = self.collection_name if self.respond_to? :collection_name
      path ||= "#{self.name}"
      return path
    end

    # Returns a json listing of fields. The values of fields will and field types (if possible)
    def json_spec_schema(spec)
      Data.export(self.name, spec, DummyUtil.new)
    end

    # Iterate over all the specs defined in the current class
    def each_json_spec(&block)
      Data.each(json_spec_path, &block)
    end

    # Registered a new spec of a given name
    def json_spec(name, &block)
      # Parse the input token data
      Generator.generate(json_spec_path, name, &block)
    end
  end

  def self.included(target)
    raise "JsonSpec must be prepended."
  end

  # Set up the default spec
  def self.prepended(target)
    target.send(:extend, Extender)
  end

  # Export item as JSON of a given spec. An invalid spec will generate
  # an exception
  def to_json(options = {})
    if options.has_key?(:spec)
      Data.export(self.class.json_spec_path, options[:spec], self)
    else
      super
    end
  end

  # Wraps the proper to_json call for use with rails render method
  def as_json(options = {})
    if options.has_key?(:spec)
      RunnerUtil.new(self.class.json_spec_path, options[:spec], self)
    else
      super
    end
  end
end