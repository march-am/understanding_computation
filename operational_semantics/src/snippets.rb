#snippets

require './big-step_semantics'

statement1 = While.new(
  LessThan.new(Variable.new(:x), Number.new(10)),
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))
  )
)

# This statement causes "stack level too deep (SystemStackError)" without using "TCO"
statement2 = While_with_tco.new(
  LessThan.new(Variable.new(:x), Number.new(100000)),
  Sequence.new(
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
    While_with_tco.new(
      LessThan.new(Variable.new(:y), Number.new(100000)),
      Assign.new(:y, Add.new(Variable.new(:y), Number.new(1)))
    )
  )
)

p statement1.evaluate({ x: Number.new(1) })
p statement2.evaluate({ x: Number.new(1), y: Number.new(1) })
