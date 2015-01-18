module RBFS
  module Serializer
    def serialize_named_object(name)
      serialized_data = serialize
      "#{name}:#{serialized_data.size}:#{serialized_data}"
    end

    def serialize_hash(hash)
      serialized_data = hash.map do |name, object|
        object.serialize_named_object(name)
      end.join
      "#{hash.size}:#{serialized_data}"
    end
  end

  class File
    include Serializer

    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    def data_type
      case @data
        when NilClass              then :nil
        when String                then :string
        when Symbol                then :symbol
        when Fixnum, Float         then :number
        when FalseClass, TrueClass then :boolean
      end
    end

    def serialize
      "#{data_type}:#{@data}"
    end

    def self.parse(string_data)
      type, data = string_data.split(':', 2)

      new FileParser.string_to_object(type.to_sym, data)
    end

  end

  class Directory
    include Serializer

    attr_reader :files
    attr_reader :directories

    def initialize
      @files = {}
      @directories = {}
    end

    def add_file(name, file)
      @files[name] = file
    end

    def add_directory(name, directory = Directory.new)
      @directories[name] = directory
    end

    def [](name)
      @directories[name] || @files[name]
    end

    def serialize
      serialize_hash(@files) + serialize_hash(@directories)
    end

    def self.parse(data)
      directory = new

      DirectoryParser.new(data, directory).run

      directory
    end
  end

  class FileParser
    def self.string_to_object(type, string)
      case type
        when :nil     then nil
        when :string  then string.to_s
        when :symbol  then string.to_sym
        when :number  then string_to_number string
        when :boolean then string == 'true'
      end
    end

    def self.string_to_number(str)
      if str.include? '.'
        str.to_f
      else
        str.to_i
      end
    end
  end

  class DirectoryParser
    def initialize(string, directory)
      @string = string
      @directory = directory
    end

    def run
      each(File) do |name, object|
        @directory.add_file(name, object)
      end
      each(Directory) do |name, object|
        @directory.add_directory(name, object)
      end
    end

    def each(type_class)
      hash_size, @string = @string.split(':', 2)
      hash_size.to_i.times do
        yield parse_named_object(type_class)
      end
    end

    def parse_named_object(type_class)
      name, size, @string = @string.split(':', 3)
      size = size.to_i
      current_string, @string = [@string[0..size - 1], @string[size..-1]]
      [name, type_class.parse(current_string)]
    end
  end
end