# rubocop:disable Style/CaseEquality, Style/For, Style/ExplicitBlockArgument, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Metrics/PerceivedComplexity

module Enumerable
  def my_each
    return enum_for unless block_given?

    for item in self do
      yield item
    end
    self
  end

  def my_each_with_index
    return enum_for unless block_given?

    i = 0
    if is_a?(Hash)
      for item in self do
        yield(item, i)
        i += 1
      end
    elsif is_a?(Range)
      arr = *self
      for item in arr do
        yield(item, i)
        i += 1
      end
    else
      for item in self do
        yield(item, i)
        i += 1
      end
    end
    self
  end

  def my_select
    return enum_for unless block_given?

    arr = []
    for item in self do
      arr << item if yield(item)
    end
    arr
  end

  def my_all?(pattern = nil)
    return false if self == false || nil?

    if pattern.nil? && !block_given?
      my_each { |item| return false unless item }
      return true
    end
    if pattern
      my_each { |item| return false unless item === pattern }
      return true
    end
    my_each { |item| return false if yield(item) === false }

    true
  end

  def my_any?(pattern = nil)
    return false if self == false || nil?

    if pattern.nil? && !block_given?
      my_each { |item| return true if item }
      return false
    end
    if pattern
      my_each { |item| return true if item === pattern }
      return false
    end
    my_each { |item| return true if yield(item) === true }

    false
  end

  def my_none?(pattern = nil)
    return true if self == false || nil?

    if pattern.nil? && !block_given?
      my_each { |item| return false if item }
      return true
    end

    if pattern
      my_each { |item| return false if item === pattern }
      return true
    end
    my_each { |item| return false if yield(item) === true }

    true
  end

  def my_count(number = nil)
    arr = *self if is_a?(Range)
    return arr.length unless block_given? || !number.nil?

    unless number.nil?
      i = 0
      for item in arr do
        i += 1 if item == number
      end
      return i
    end

    my_select { |x| yield(x) }.length
  end

  def my_inject(*args)
    memo = first
    if args[0].is_a?(Integer)
      memo = args.first
      args.shift
    end
    sym = args.first if args[0].is_a?(Symbol)
    if sym
      my_each { |item| memo = memo ? memo.send(sym, item) : item }
    else
      my_each { |item| memo = yield(memo, item) }
    end
    memo / first
  end

  def my_map(proc = nil)
    return enum_for unless block_given?

    fin = []
    if proc
      my_each { |x| fin << proc.call(x) }
    else
      my_each { |x| fin << yield(x) }
    end
    fin
  end
end

def multiply_els(array)
  array.my_inject(1, :*)
end
p [1, 2, 3].my_inject
# rubocop:enable Style/CaseEquality, Style/For, Style/ExplicitBlockArgument, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Metrics/PerceivedComplexity
