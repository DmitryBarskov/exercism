# What I learned solving exercises in order

## [Hello world](./hello-world/README.md)

* [`mix test` - Elixir's test execution tool](https://hexdocs.pm/mix/Mix.Tasks.Test.html)

`mix test` command runs tests.

* [`ExUnit` - Elixir's unit test library](https://hexdocs.pm/ex_unit/ExUnit.html)

File structure:
```
.
├── lib
│   └── hello_world.ex
├── mix.exs
└── test
    ├── hello_world_test.exs
    └── test_helper.exs
```

File `test_helper.exs` is optional:

Test example:
```elixir
defmodule HelloWorldTest do
  use ExUnit.Case

  test "says 'Hello, World!'" do
    assert HelloWorld.hello() == "Hello, World!"
  end
end
```

`@doc` decorator defines a documentation string for a function:
```elixir
defmodule SomeModule do
  @doc "Prints 'Hello, world!' to stdout"
  def some_function do
    IO.puts("Hello, world!")
  end
end
```

Then in `iex` the module can be compiled and the doc can be shown:
```
iex(1)> c("some_module.ex", ".")
[SomeModule]
iex(2)> h(SomeModule.some_function)
...
Prints 'Hello, world!' to stdout
```

`@spec` defines type for a function, [dailyxir](https://github.com/jeremyjh/dialyxir)
can be used for type checking.
```
defmodule BirdCount do
  @doc "returns today's bird count"
  @spec today(list) :: integer() | nil
  def today([]), do: nil
  def today([today | _rest]), do: today
end
```

## [Lasagna](./lasagna/README.md)

Functions in Elixir must be in modules, `defmoudle` creates a moudle,
`def` creates a function, `defp` creates a private function:

```elixir
defmodule SomeModule do
  def some_function do
    IO.puts("Hello, world!")
  end
end

SomeModule.some_function # prints Hello, world!
```

Elixir is dynamically typed, we can re-bind variables:
```elixir
count = 1
count = count + 1
count = "Three"
```

One-line function definition (defines `OneLiner.add/2`, `2` is arity here):
```elixir
defmodule OneLiner do
  def add(x, y), do: x + y
end
```

## [Pacman Rules](./pacman-rules/README.md)

Variables are named in _snake_case_. They can end with `?` (question mark).
Use values `true` and `false`, operators `and/2`, `or/2` and `not/1` for
boolean expressions.

```elixir
success? = false
true and false
success? or true
not success?
```

## [Freelancer Rates](./freelancer-rates/README.md)

There are `Float.floor`, `Float.ceil`, `Float.round`, `Kernel.floor`,
`Kernel.ceil` and `Kernel.round` functions.

Functions in `Float` module take 2 arguments and do rounding
to the specified digit,
while `Kernel` ones take one argument and round to an integer.
```elixir
Float.round(5.5675, 3) #=> 5.567
ceil(10.1) #=> 11
```

To drop floating point part use `Kernel.trunc/1`. `Kernel` functions can be
called wihtout module name: `Kernel.trunc(3.4) #=> 3` and `trunc(3.4) #=> 3`.

## [Log Level](./log-level/README.md)

Use cond for if-else-if kind of logic.

```elixir
cond do
  1 + 2 == 3 -> "as expected"
  1 + 2 != 3 -> "I'm insane"
  true -> "man I'm dead"
end
```

Atoms are constants named as their values. They are like strings, but stored
in lookup table in memory. For example `:ok, :error, :hello_world` are atoms.
Values `true` and `false` are references to atoms `:true` and `:false`.

Equality: `1 == 1.0 #=> true` and stricter version `1 === 1.0 #=> false`.

## [Language List](./language-list/README.md)

List is a built-in type in elixir implemneted by linked list. They can include
different types.
```elixir
some_list = [1, "2", :three]
```

`|` is used to prepending an item to list, but the whole new list must be
wrapped with `[]`:
```elixir
[0 | some_list]
[1 | [2 | [3]]] = [1, 2, 3]
[1, 2 | [3, 4]] = [1, 2, 3, 4]
```

Some basic functions to work with lists:
```elixir
1 in [1, 2, 3] = true # check if element is in list
[1 | [3, 4, 5]] = [1, 3, 4, 5] # prepend
[1, 2, 3] ++ [4, 5, 6] = [1, 2, 3, 4, 5, 6] # concat lists
[1, 2, 1, 3] -- [1, 3] = [2, 1] # remove first occurrences
hd [1, 2, 3] = 1 # first element of list
tl [1, 2, 3] = [2, 3] # elements except first
length([1, 2, 3]) = 3 # length of list
```

Objects can't be mutated. The statemnt `count = count + 1` actually _re-binds_
`count`. So when adding an item to a list we have to re-bind the variable we
store the list in:
```elixir
language_list = LanguageList.new() # => []
language_list = LanguageList.add(language_list, "Clojure") # => ["Clojure"]
```

## [Secrets](./secrets/README.md)

Anonymous functions can be created, saved to a variable,
returned from a function etc.

```elixir
function_variable = fn param ->
  param + 1
end

function_variable.(1) # => 2

short = &(&1 * &2 + &3)

short.(5, 6, 7) #=> 37
```

`Bitwise` module contains functions to manipulate bits:

- `band/2`: bitwise AND
- `bsl/2`: bitwise SHIFT LEFT
- `bsr/2`: bitwise SHIFT RIGHT
- `bxor/2`: bitwise XOR
- `bor/2`: bitwise OR
- `bnot/1`: bitwise NOT

These functions can be referred using the module (`Bitwise.band(1, 2)`) or
importing `Bitwise` into your module:

```elixir
defmodule PowerOfTwo do
  import Bitwise
  # or
  # import Bitwise, only: [band: 2, bxor: 2] # specify functions with arity

  def power_of_two?(num), do: num > 0 and band(num, num - 1) == 0
end
```

## [Guessing Game](./guessing-game/HINTS)

Elixir functions can have multiple definitions (clauses).
Pattern matching works in function parameters. The first matching function
clause will be invoked.
```elixir
def even?(0), do: true
def even?(1), do: false
def even?(2), do: true
def even?(3), do: false
```

Use gaurd clauses for more complex matching, but still
guard clauses can only be guards and combination of them. Guards in Elixir
are simple functions and macros.
Unused parameters should start with `_` (underscore).
```elixir
def even?(n) when n % 2 == 0, do: true
def even?(_), do: false
```

Use separate function definition for default parameter values
when function have multiple clauses (parameters with default values can precede
parameter without default values).
```elixir
def number_to_string(number, radix \\ 10)
def number_to_string(1, _), do: "1"
def number_to_string(2, 2), do: "10"
def number_to_string(3, 2), do: "11"
```

## [Kitchen Calculator](./kitchen-calculator/README.md)

Tuples are like immutable arrays that can hold values with different data types.
These are tuples `{}`, `{42}`, `{:ok, 5, "hello"}`.

`Kernel.elem/2` can be used to access tuples' items. `elem({:ok, 42}, 1) # => 42`.

Pattern matching works with tuples:
```elixir
cond IO.puts("Hello, world!") do
  {:error, reason} -> IO.puts(:stderr, "Could not print to stdio due to " <> reason)
  :eof -> IO.puts(:stderr, "stdio is closed")
  data -> IO.puts("successfully printed " <> data)
end
```

Pattern matching in named functions:
```elixir
defmodule ResponseHandling do
  def handle_response({:ok, data}) do
    IO.puts(data)
  end

  def handle_response({:error, message} = whole_err) do
    IO.inspect(whole_tuple)
    IO.puts(:stderr, message)
  end
end

# prints "Hello" to stdout
ResponseHandling.handle_response({:ok, "Hello"})

# prints "{:ok, "Hello"}" to stdout and "Hello" to stderr
ResponseHandling.handle_response({:error, 404})

# FunctionClauseError will occur
ResponseHandling.handle_response({:success, :fail})
```

## [High School Sweetheart](./high-school-sweetheart/README.md)

```elixir
"Strings" <> " in " <> "Elixir"
"Interpolation is #{6 * 7}"
"""
and multiline
strings
"""
```

### pipe operator

Left operand of `|>` is passed as the first argument to next function call.

```elixir
"hey"
|> String.upcase
|> Kernel.<>("!")
#=> HEY!
```

## [Rational Numbers](./rational-numbers/README.md)

Learn about `Integer.pow`, `Float.pow`, `Kernel.abs`.

If a function in the module has the same name as in `Kernel`, it must be referred
with module name:

```elixir
defmodule RationalNumbers do
  def abs({numerator, denominator}) do
    {Kernel.abs(numerator), Kernel.abs(denominator)}
  end
end
```

## [Bird Count](./bird-count/README.md)

Recursion + pattern matching + multiple function clauses = awesome

## [Name Badge](./name-badge/README.md)

There is `nil` in Elixir (same thing as `None`, `null` in other languages).

There is `if` macro (which is expression):

```elixir
is_even = if Integer.mod(42, 2) do
  :yes
else
  :no
end

is_even = if Integer.mod(42, 2), do: :yes, else: :no
```

`if` can take not only boolean values, but all values.
But only `false` and `nil` behave as `false`, all other values behave as `true`.

While `not`, `and` etc can be used only for boolean values,
`!`, `&&`, `||` can be used for all values including booleans.

## [Wine Cellar](./wine-cellar/README.md)

Keyword lists are a key-value data structure.

```elixir
[month: "April", year: 2018]
```

Keyword lists are lists of `{key, value}` tuples, and can also be written like:

```elixir
[month: "April"] == [{:month, "April"}] # => true
```

Since it is a list, it can have repeating keys.

```elixir
[a: 2, b: 3, a: 1][:a] #=> 2
Keyword.get_values([a: 2, b: 3, a: 1], :a) #=> [2, 1]
```

Pattern matching on a keyword-list:
```elixir
defmodule KwList do
  def matching([{:year, year} | rest]), do: ["Year is #{year}" | matching(rest)]
  def matching([{:country, country} | rest]), do: ["Country is #{country}" | matching(rest)]
  def matching(_), do: []
end

KwList.matching(year: 1988, country: "France", model: "A320") # can omit [ and ]
#=> ["Year is 1988", "Country is France"]
```

## [Take-A-Number](./take-a-number/README.md)

To create an Elixir process use `spawn/1` (don't confuse with OS processes).
`spawn` takes a function to execute and returns a PID.
`spawn(fn -> 2 + 2 end) # => #PID<0.125.0>`
Send a message to a process using `send/2` which takes a PID and a value to send.

```elixir
send(self, :test)
receive do
  :test -> IO.puts("Received :test!")
  other -> IO.puts("Unexpected message #{other}")
end
#=> Received :test!
```

`receive/1` takes only one message from the mailbox. If there are no messages
in the mailbox, it will block current's process execution until message is sent.

`&function/arity` syntax can be used to pass it to `spawn`:

```elixir
spawn(&loop/0)
```

`spawn` can take 3 arguments:

```elixir
spawn(TakeANumber, :loop, [0])
```

## [High Score](./high-score/README.md)

Map in Elixir:
```elixir
%{atom_key: 1, 1 => :atom_value, "other_type_of_key" => :atom_value}

%{a: 1}[:a] #=> 1
%{a: 1}[:b] #=> nil
%{a: 1}.a #=> 1
%{a: 1}.b # ** (KeyError) key :b not found in: %{a: 2}
Map.fetch(%{a: 2}, :a) #=> {:ok, 2}
Map.fetch(%{a: 2}, :b) #=> {:error}
Map.get(%{a: 2}, :b, 3) #=> 3
```

[etc](https://hexdocs.pm/elixir/1.18.4/Map.html). Worth mentioning:
`filter/2`, `get_and_update/3`, `has_key?/2`, `put/3`, `update/4`, `to_list/1`,
`values/1`, `keys/1`, `new/1`, `delete/2`.

In Elixir, we can define module attributes which can be used as constants in our functions.
Their value can be any expression which can be evaluated at compilation time.
After compilation, module attributes are not accessible since they are expanded during compilation.

```elixir
defmodule Example do
  # Defines the attribute as the value 1
  @constant_number 1

  def example_value() do
    @constant_number
  end
end
```

## [Boutique Inventory](./boutique-inventory/README.md)

`Enum` module contains useful functions, such as `map/2`, `filter/2`, `join/2`,
`map_join/3`, `all?/2`, `reduce/3`, `reduce_while/3`, `into/2`
and [many more](https://hexdocs.pm/elixir/1.18.4/Enum.html).

To `Enum.map` on maps, also use these functions: `Enum.into`, `Map.new`.

These functions work for types implementing Enumerable protocol, including
`List`, `Map`, `Range`.

Pattern matching on a map:
```
%{b: b_value} = %{a: 2, b: 3, c: 4}
b_value #=> 3
```

### Protocols

```elixir
defprotocol Reversible do
  def reverse(term)
end

defimpl Reversible, for: List do
  def reverse(term) do
    Enum.reverse(term)
  end
end

Reversible.reverse([1, 2, 3]) #=> [3, 2, 1]
Reversible.reverse(%{}) #=> ** (Protocol.UndefinedError) protocol Reversible not implemented for type Map
```
