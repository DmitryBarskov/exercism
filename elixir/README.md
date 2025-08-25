# What I learned solving exercises in order

## hello-world

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

<!-- TODO: @doc @spec -->

## lasagna

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

## pacman-rules

Variables are named in _snake_case_. They can end with `?` (question mark).
Use values `true` and `false`, operators `and/2`, `or/2` and `not/1` for
boolean expressions.

```elixir
success? = false
true and false
success? or true
not success?
```

## freelancer-rates

<!-- TODO: add section -->

## secrets

<!-- TODO: add section -->

## log-level

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

## language-list

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

## guessing-game

Creating anonymous function:
```elixir
func = fn param ->
  param + 1
end
func.(1) = 2

short = &(&1 + 1)
short.(1) = 2
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

## guessing-game

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

## kitchen-calculator

Tuples are like immutable arrays that can hold values with different data types.
These are tuples `{}`, `{42}`, `{:ok, 5, "hello"}`.

`elem/2` can be used to access tuples' items. `elem({:ok, 42}, 1) # => 42`.

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

# prints
#=> Hello
# to stdout
ResponseHandling.handle_response({:ok, "Hello"})

# prints
#=> {:ok, "Hello"}
# to stdout and
#=> Hello
# to stderr
ResponseHandling.handle_response({:error, 404})

# FunctionClauseError will occur
ResponseHandling.handle_response({:success, :fail})
```

## high-school-sweetheart

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

## rational numbers

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
G
