def series(type, target)
  return fibonacci(target) if type.eql? 'fibonacci'
  return lucas(target) if type.eql? 'lucas'
  return fibonacci(target) + lucas(target) if type.eql? 'summed'
  end
end

def fibonacci(target)
  return 1 if (1..2).include? target
  fibonacci(target - 1) + fibonacci(target - 2) if target > 2
end

def lucas(target)
  return 2 if target.eql?1
  return 1 if target.eql?2
  lucas(target - 1) + lucas(target - 2) if number > 2
end