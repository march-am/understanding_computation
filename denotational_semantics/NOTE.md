##  p.47~ Denotational Semantics

### p.48 式の実装 Number

```Ruby
Number.new(5).to_ruby
# => "-> e { 5 }"
Boolean.new(false).to_ruby
# => "-> e { false }"
```

```Ruby
proc = eval(Number.new(5).to_ruby)
# => #<Proc (lambda)>
proc.call({})
# => 5
proc = eval(Boolean.new(false).to_ruby)
# => #<Proc (lambda)>
proc.call({})
# => false
```

### p.49 式の実装 Variable

```Ruby
expression = Variable.new(:x)
# => «x»
expression.to_ruby
# => "-> e { e[:x] }"
proc = eval(expression.to_ruby)
# => #<Proc (lambda)>
proc.call({ x: 7 })
# => 7
```

### p.50 式の実装 Add/LessThan

```Ruby
Add.new(Variable.new(:x), Number.new(1)).to_ruby
# => "-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }"
LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby
# => "-> e { (-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }).call(e) < (-> e { 3 }).call(e) }"
```

#### 検算

```Ruby
environment = { x: 3 }
# => {:x=>3}
proc = eval(Add.new(Variable.new(:x), Number.new(1)).to_ruby)
# => #<Proc (lambda)>
proc.call(environment)
# => 4
proc = eval(
  LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby
)
# => #<Proc (lambda)>
proc.call(environment)
# => false
```

### p.51 文の実装 Assign

```Ruby
statement = Assign.new(:y, Add.new(Variable.new(:x), Number.new(1)))
# => «y = x + 1»
statement.to_ruby
# => "-> e { e.merge({ :y => (-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }).call(e) }) }"
proc = eval(statement.to_ruby)
# => #<Proc (lambda)>
proc.call({ x: 3 })
# => {:x=>3, :y=>4}
```

### p.52 文の実装 While

```Ruby
statement = While.new(
  LessThan.new(Variable.new(:x), Number.new(5)),
  Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
)
# => «while (x < 5) { x = x * 3 }»
statement.to_ruby
# => "-> e { while (-> e { (-> e { e[:x] }).call(e) < (-> e { 5 }).call(e) }).call(e); e = (-> e { e.merge({ :x => (-> e { (-> e { e[:x] }).call(e) * (-> e { 3 }).call(e) }).call(e) }) }).call(e); end; e }"
proc = eval(statement.to_ruby)
# => #<Proc (lambda)>
proc.call({ x: 1 })
# => {:x=>9}
```
