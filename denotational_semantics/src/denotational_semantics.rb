#Denotational Semantics

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

  def to_ruby
    "-> e { #{value.inspect} }"
  end
end


class Boolean < Struct.new(:value)
  include Inspectable

  def to_s
    value.to_s
  end

  def to_ruby
    "-> e { #{value.inspect} }"
  end
end


class Variable < Struct.new(:name)
  include Inspectable

  def to_s
    name.to_s
  end

  def to_ruby
    "-> e { e[#{name.inspect}] }"
  end
end


class Add < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} + #{right}"
  end

  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) + (#{right.to_ruby}).call(e) }"
  end
end


class Multiply < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} * #{right}"
  end

  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) * (#{right.to_ruby}).call(e) }"
  end
end


class LessThan < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} < #{right}"
  end

  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) < (#{right.to_ruby}).call(e) }"
  end
end


class DoNothing
  include Inspectable

  def to_s
    "do-nothing"
  end

  def ==(other_statement)
    other_statement.instance_of?(DoNothing)
  end

  def to_ruby
    '-> e { e }'
  end
end


class Assign < Struct.new(:name, :expression)
  include Inspectable

  def to_s
    "#{name} = #{expression}"
  end

  def to_ruby
    "-> e { e.merge({ #{name.inspect} => (#{expression.to_ruby}).call(e) }) }"
  end
end


class If < Struct.new(:condition, :consequence, :alternative)
  include Inspectable

  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def to_ruby
    "-> e { if (#{condition.to_ruby}).call(e)" +
      " then (#{consequence.to_ruby}).call(e)" +
      " else (#{alternative.to_ruby}).call(e)" +
      " end }"
  end
end


class Sequence < Struct.new(:first, :second)
  include Inspectable

  def to_s
    "#{first}; #{second}"
  end

  def to_ruby
    "-> e { (#{second.to_ruby}).call((#{first.to_ruby}).call(e)) }"
  end
end


class While < Struct.new(:condition, :body)
  include Inspectable

  def to_s
    "while (#{condition}) { #{body} }"
  end

  def to_ruby
    "-> e {" +
      " while (#{condition.to_ruby}).call(e); e = (#{body.to_ruby}).call(e); end;" +
      " e" +
      " }"
  end
end
