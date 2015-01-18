def series(type, target)
  if type == 'fibonacci' then fibonacci(target)
  elsif type == 'lucas' then lucas(target)
  elsif type == 'summed' then fibonacci(target) + lucas(target)
  end
end

def fibonacci(target)
  number = [1,1]
  for index in 2..target
    number[index] = number[index-1] + number[index-2]
  end
  number[target-1]
end

def lucas(target)
  number = [2,1]
  for index in 2..target
    number[index] = number[index-1] + number[index-2]
  end
  number[target-1]
end