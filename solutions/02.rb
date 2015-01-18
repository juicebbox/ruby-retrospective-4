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
    @array.each_with_object(NumberSet.new) do |number, new_set|
      new_set << number if filter.satisfied_by? number
    end
  end
end

class Filter

  def initialize(&block)
    @filter = block
  end

  def satisfied_by?(number)
    @filter.call number
  end

  def apply_filter(array)
    array.select(&@block)
  end

  def & (other)
    Filter.new { |number| satisfied_by? number and other.satisfied_by? number }
  end

  def | (other)
     Filter.new { |number| satisfied_by? number or other.satisfied_by? number }
  end
end



class TypeFilter < Filter
  def initialize(type)
    case type
    when :integer then super() { |number| number.integer? }
    when :complex then super() { |number| not number.real? }
    when :real    then super() { |number| number.real? and not number.integer? }
    end
  end
end

class SignFilter < Filter
  def initialize(sign)
    case sign
    when :positive     then super() { |number| number > 0 }
    when :negative     then super() { |number| number < 0 }
    when :non_positive then super() { |number| number <= 0 }
    when :non_negative then super() { |number| number >= 0 }
    end
  end
end