module Inspectable
  def inspect
    "<<#{self}>>"
  end
end


class Number < Struct.new(:value)
  include Inspectable

  def to_s
    value.to_s
  end

  def reducible?
    false
  end
end


class Add < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} + #{right}"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value + right.value)
    end
  end
end


class Multiply < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} * #{right}"
  end

  def reducible?
    true
  end


  def reduce(environment)
    if left.reducible?
      Multiply.new(left.reduce(environment), right)
    elsif right.reducible?
      Multiply.new(left, right.reduce(environment))
    else
      Number.new(left.value * right.value)
    end
  end
end


class Boolean < Struct.new(:value)
  include Inspectable

  def to_s
    value.to_s
  end

  def reducible?
    false
  end
end


class LessThan < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} < #{right}"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      LessThan.new(left.reduce(environment), right)
    elsif right.reducible?
      LessThan.new(left, right.reduce(environment))
    else
      Boolean.new(left.value < right.value)
    end
  end
end


class Variable < Struct.new(:name)
  include Inspectable

  def to_s
    name.to_s
  end

  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end
end


class Machine < Struct.new(:expression, :environment)

  def step
    self.expression = expression.reduce(environment)
  end

  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end
