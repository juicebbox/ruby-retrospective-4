class NumberSet
  include Enumerable
  def initialize(array = [])
    @array = array
  end

  def each(&block)
    @array.each(&block)
  end

  def <<(number)
    @array << number unless @array.include? number
  end

  def size
    @array.size
  end

  def empty?
    @array.empty?
  end

  def [] (filter)
    NumberSet.new(filter.apply_filter(@array))
  end
end

class Filter

  def initialize(&block)
    @block = block
  end

  def apply_filter(array)
    array.select(&@block)
  end

  def & (filter)
  end

  def | (filter)
  end
end



class TypeFilter < Filter
  def initialize(type)
    @type = type
  end

  def check_type (number)
    case @type
      when :integer
        number.is_a? Integer
      when :complex
        number.is_a? Complex
      when :real
        number.is_a? Rational or number.is_a? Float
    end
  end

  def apply_filter(array)
    filtered_array = []
    array.each do |number|
      if check_type(number)
        filtered_array << number
      end
    end
    filtered_array
  end
end


class SignFilter < Filter
  def initialize(sign)
    @sign = sign
  end

  def check_sign (number)
    if @sign == :positive
        number > 0
    elsif @sign == :non_positive
        number <= 0
    elsif @sign == :negative
        number < 0
    elsif @sign == :non_negative
        number >= 0
    end
  end
  def apply_filter(array)
    filtered_array = []
    array.each do |number|
      if check_sign(number)
        filtered_array << number
      end
    end
    filtered_array
  end
end