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
```elixir
iex(1)> c("some_module.ex", ".")
[SomeModule]
iex(2)> h(SomeModule.some_function)
# ...
# Prints 'Hello, world!' to stdout
```

`@spec` defines type for a function, [dailyxir](https://github.com/jeremyjh/dialyxir)
can be used for type checking.
```elixir
defmodule BirdCount do
  @doc "returns today's bird count"
  @spec today(list) :: integer() | nil
  def today([]), do: nil
  def today([today | _rest]), do: today
end
```

## [Lasagna](./lasagna/README.md)

Functions in Elixir must be in modules, `defmodule` creates a moudle,
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

## [Log Parser](./log-parser/README.md)

### Regular expressions

```elixir
"this string includes a test" =~ ~r/test/ # => true

String.match?("Hello world! 42!", ~r/\d{3}/) # => false

String.match?("123", ~r/^[[:alnum:]]+$/) #=> true

Regex.run(~r/(\b\w{3}\b)/i, "Hello there, how are you?")
#=> ["how", "how"]

Regex.scan(~r/(\b\w{3}\b)/i, "Hello there, how are you?")
#=> [["how", "how"], ["are", "are"], ["you", "you"]]

```

### Other sigils

Sigils start with the tilde (`~`) character which is followed by either
a single lower-case letter or
one or more upper-case letters,
and then a delimiter.
Optional modifiers are added after the final delimiter.

The available delimiters are: `//`, `||`, `""`, `''`, `()`, `[]`, `{}`, `<>`.

```elixir
~r/foo|bar/i # regex
~s|this this a simple string but can contain a " without escaping| # string
~c"charlist" # charlist
~w'this is a word list' #=> ["this", "is", "a", "word", "list"]
~w(this is a list of atoms)a #=> [:this, :is, :a, :list, :of, :atoms]
~w(list of char lists)c #=> [~c"list", ~c"of", ~c"char", ~c"lists"]
~D[2019-10-31] # date
~T[23:00:07.0] # time
~N[2019-10-31 23:00:07] # naive date time
~U[2019-10-31 19:59:03Z] # UTC date time
```

## [Remote Control Car](./remote-control-car/README.md)

Struct in elixir are built based on maps.

```elixir
defmodule Plane do
  defstruct [:engine_model, engine_count: 2]
end

%Plane{} #=> %Plane{engine_model: nil, engine_count: 2}

plane = %Plane{engine_model: "IAE V2500"}
plane #=> %Plane{engine_model: "IAE V2500", engine_count: 2}
plane.engine_model #=> "IAE V2500"

Map.keys(plane) #=> [:__struct__, :engine_model, :engine_count]
Map.values(plane) #=> [Plane, "IAE V2500", 2]

Map.put(plane, :engine_model, "PW6000")
#=> %Plane{engine_model: "PW6000", engine_count: 2}

Map.put(plane, :seats, 150)
#=> %{__struct__: Plane, engine_model: "IAE V2500", engine_count: 2, seats: 150}

%{plane | engine_count: 4}
#=> %Plane{engine_model: "IAE V2500", engine_count: 4}

%Plane{engine_model: engine_model} = plane
engine_model #=> "IAE V2500"
```

To make an attribute required, use `@enforce_keys`:

```elixir
defmodule User do
  @enforce_keys [:age]
  defstruct [:age]
end

%User{}
# ** (ArgumentError) the following keys must also be given when building struct User: [:age]
```

## [RPN Calculator](./rpn-calculator/README.md)

In elixir methods with `!` raise errors.
```elixir
Map.fetch(%{a: 1}, :b) #=> :error
Map.fetch!(%{a: 1}, :b) #=> ** (KeyError) key :b not found in: %{a: 1}
```
But preferred way is to handle returned values.

Still errors can be thrown and caught like this:
```elixir
try do
  raise RuntimeError, "something went wrong"
rescue
  e in RuntimeError -> {:error, e.message}
end #=> {:error, "something went wrong"}
```

User exceptions can be declared using `defexception`:

```elixir
defmodule MyError do
  defexception as_text: "default message"
end

try do
  raise MyError, as_text: "Hello world!"
rescue
  RuntimeError -> :error
  e in MyError -> {:my_error, e.as_text}
end #=> {:my_error, "Hello world!"}
```

> ### Fail fast / Let it crash
> One saying that is common in the Erlang community, as well as Elixir's,
> is "fail fast" / "let it crash". The idea behind let it crash is that,
> in case something unexpected happens, it is best to let the exception happen,
> without rescuing it.
> It is important to emphasize the word _unexpected_. For example, imagine
> you are building a script to process files. Your script receives filenames
> as inputs. It is expected that users may make mistakes and provide unknown
> filenames. In this scenario, while you could use `File.read!/1` to read files
> and let it crash in case of invalid filenames, it probably makes more sense
> to use `File.read/1` and provide users of your script with a clear and
> precise feedback of what went wrong.
> At the end of the day, "fail fast" / "let it crash" is a way of saying that,
> when something unexpected happens, it is best to start from scratch within
> a new process, freshly started by a supervisor, rather than blindly trying to
> rescue all possible error cases without the full context of when and
> how they can happen.

### Reraise

Sometimes errors are needed, e.g. for logging and observability:

```elixir
require Logger

try do
  raise "Oops"
rescue
  e ->
    Logger.error(Exception.format(:error, e, __STACKTRACE__))
    reraise e, __STACKTRACE__
end
```

### Throw

`throw` can be used to control the flow like with exceptions, but with
regular values. !VERY DISCOURAGED!

```elixir
try do
  Enum.each(-50..50, fn x ->
    if rem(x, 13) == 0, do: throw(x)
  end)
  "Got nothing"
catch
  x -> "Got #{x}"
end #=> "Got -39"

# Equivalent code, but without throw:
case Enum.find(-50..50, fn x -> rem(x, 13) == 0 end) do
  nil -> "Got nothing"
  x -> "Got #{x}"
end #=> "Got -39"
```

## [RPN Calculator Inspection](./rpn-calculator-inspection/README.md)

Processes isolated by default, but can be linked using `spawn_link/1` or
`Process.link/1`. Linked processes crash together.

Parent process spawns another process, it crashes. Then "You OK?" is sent to
parent to check if it is alive.
```elixir
parent = spawn(fn ->
  child = spawn(fn -> raise "Child: oops!" end)
  receive do
    {_, sender} -> send(sender, "Parent: I'm still OK")
  end
end)

send(parent, {"You OK?", self})
receive do
  msg -> "Received '#{msg}'"
end #=> "Received 'Parent: I'm still OK'"
```

Same example, but child process is being spawned using `spawn_link/1`,
parent does not respond to "You OK?".
```elixir
parent = spawn(fn ->
  child = spawn_link(fn -> raise "Child: oops!" end)
  # or spawn using `spawn/1` and then call Process.link(child)
  Process.link(child)
  receive do
    {_, sender} -> send(sender, "Parent: I'm still OK")
  end
end)

send(parent, {"You OK?", self})
receive do
  msg -> "Received '#{msg}'"
end # *no response, press ^C*
```

Parent process can receive information about exiting of children:
```elixir
parent = spawn(fn ->
  Process.flag(:trap_exit, true)
  child = spawn_link(fn -> raise "Child: oops!" end)
  # will receive 2 messages, one from child exiting
  # the other one from send(parent, {"You OK?", self}) line
  Enum.each(1..2, fn _ ->
    receive do
      {:EXIT, ^child, reason} ->
        IO.puts("Parent: My child exited due")
        IO.inspect(reason)
      {_, sender} -> send(sender, "Parent: I'm still OK")
    end
  end)
end)
#=> Parent: My child exited due {%RuntimeError{message: "Child: oops!"}, []}

send(parent, {"You OK?", self})
receive do
  msg -> "Received '#{msg}'"
end #=> "Received 'Parent: I'm still OK'"
```

### Tasks

`Task.async/1` creates an asynchronous task, returning `%Task{}` struct.
To wait it to complate use `Task.await/2` function with timeout.

```elixir
t = Task.async(fn -> "Result from async task!" end)
#=> %Task{
#=>   mfa: {:erlang, :apply, 2},
#=>   owner: #PID<0.105.0>,
#=>   pid: #PID<0.110.0>,
#=>   ref: #Reference<0.0.13443.1909499269.3852795906.116663>
#=> }
Task.await(t) #=> "Result from async task!"
```

To start a task for side effect only use `Task.start/1` or `Task.start_link/1`.

## [Parallel Letter Frequency](./parallel-letter-Frequency/README.md)

## [Bob](./bob/README.md)

## [Leap](./leap/README.md)

## [German Sysadmin](./german-sysadmin/README.md)

Charlists are list of integers.

```elixir
iex(1)> [65, 66, 67]
~c"ABC"
iex(2)> [3, 66, 67]
[3, 66, 67]
iex(3)> ~c"ABC" |> hd
65
```

`case` is like cond, but works with given value:
```elixir
age = 18

case age do
  0 -> :hello_world
  age when age < 18 -> :coke
  _ -> :any_drink
end #=> :any_drink
```

## [Paint by number](./paint-by-number/README.md)

Binary data in Elixir represented by Bitstring. Bitstrings defined
using the bitstring special form `<<>>`. Each segment has a value
and type, separated by the `::` operator. The type specifies how
many bits will be used to encode the value. The type can be omitted
completely, which will default to a 8-bit integer value.

```elixir
# This defines a bitstring with three segments of a single bit each
<<0::1, 1::1, 0::1>>
```

Specifying the type as `::1` is a shorthand for writing `::size(1)`.
You need to use the longer syntax if the bit size comes
from a variable.

If the value of the segment overflows the capacity of the segment's
type, it will be truncated from the left.

```elixir
<<0b1011::3>> == <<0b0011::3>>
# => true
```

### Bitstring prepending and appending

You can both prepend and append to an existing bitstring using
`::bitstring`, this type must be used on the existing bitstring
if it's of unknown size.

```elixir
value = <<0b110::3, 0b001::3>>
new_value = <<0b011::3, value::bitstring, 0b000::3>>
#=> <<120, 8::size(4)>>
```

### Bitstring pattern matching

```elixir
iex(6)> <<a::1, b::2>> = <<0b110::3>>
<<6::size(3)>>
iex(7)> a
1
iex(8)> b
2
```

If a bitstring represents a printable UTF-8 encoded string,
it gets displayed as a string.

```elixir
<<>>
# => ""

<<65, 66, 67>>
# => "ABC"
```

## [Resistor Color Trio](./resistor-color-trio/README.md)

## [DNA Encoding](./dna-encoding/README.md)

Use tail call for recursive functions, i.e. recursive function call
should be the last __code executed in your function__.

```elixir
# Count the length of a list without an accumulator
def count([]), do: 0
def count([_head | tail]), do: 1 + count(tail)

# Count the length of a list with an accumulator
def count(list), do: do_count(list, 0)

defp do_count([], count), do: count
defp do_count([_head | tail], count), do: do_count(tail, count + 1)
```

## [All Your Base](./all-your-base/README.md)

Learned `with` and `Enum.reduce_while/3`:

```elixir
with {:ok, result1} <- func1(),
  {:ok, result2} <- func2(result1),
  {:ok, result3} <- func3(result2),
  do: result3

# If at some point a pattern won't be matched, the unmatched value is returned.
# Otherwise result3 is returned.
```

```elixir
Enum.reduce_while(1..10, 0, fn
  _, sum when sum > 20 -> {:halt, :infinity} # :halt will break execution early
  num, sum -> {:cont, sum + num} # if :halt not returned it will behave just like regular reduce/3
end)
```

Also learned about `Stream.unfold/2` after a review:

```elixir
Stream.unfold({10928, []}, fn
  nil -> nil
  {0, _} = current_value -> {current_value, nil}
  {rest, ds} = current_value -> {current_value, {div(rest, 10), [rem(rest, 10) | ds] }}
end)
#=> [
#  {10928, []},
#  {1092, [8]},
#  {109, [2, 8]},
#  {10, [9, 2, 8]},
#  {1, [0, 9, 2, 8]},
#  {0, [1, 0, 9, 2, 8]}
#]
```

It was not super convenient, since unfold returns the last `current_value`, not the next!
```elixir
Stream.unfold({10928, []}, fn
  {0, _} -> nil
  {rest, ds} = current_value -> {current_value, {div(rest, 10), [rem(rest, 10) | ds] }}
end)
#=> [
#  {10928, []},
#  {1092, [8]},
#  {109, [2, 8]},
#  {10, [9, 2, 8]},
#  {1, [0, 9, 2, 8]}
#]
```

## [Chessboard](./chessboard/README.md)

Ranges are created via the `first..last` and `first..last//step`.

```elixir
Enum.to_list(1..3)
[1, 2, 3]
Enum.to_list(3..1//-1)
[3, 2, 1]
Enum.to_list(1..5//2)
[1, 3, 5]
```

## [Captain's log](./captains-log/README.md)

Use `Enum.random` to pick an element from list, range etc.

An Erlang func should be called from its module. Erlang modules are snake cased.

```elixir
:math.pi() #=> 3.141592653589793
:timer.sleep(1) #=> :ok
:rand.uniform() #=> 0.001160346888228636
:io_lib.fwrite("hello ~s", ["world"]) # prints "hello world"
```

## [RPG Character Sheet](./rpg-character-sheet/README.md)

`IO` - module for handling input and output.

```elixir
IO.puts("Hi!") #=> :ok
# pirnts 'Hi!' to stdout
```

`IO.inspect` prints any value and returns it.

```elixir
IO.gets("What's your name?\n") #=> "Bob\n"
# prints 'What's your name?'
```

## [Strain](./strain/README.md)

## [City Office](./city-office/README.md)

Use `@moduledoc` to add docs for module and `@doc` for functions.

```elixir
defmodule MyModule do
  @moduledoc """
  Elixir docs are written in markdown
  """

  @doc """
  Does nothing

  ## Examples

      iex> MyModule.func
      nil
  """
  @spec func() :: nil
  def func(), do: nil
end
```

Compile a module and you can see its docs:

```elixir
c("my_module.ex", ".") #=> [MyModule]
h(MyModule)
#
#               MyModule
#
# Elixir docs are written in markdown
#

h(MyModule.func)
#
#               def func()
#
#  @spec func() :: nil
#
# Does nothing
#
# ## Examples
#
#    iex> MyModule.func
#    nil
#
```

### Types

Most commonly used types include:

- booleans: `boolean()`
- strings: `String.t()`
- numbers: `integer()`, `non_neg_integer()`, `pos_integer()`, `float()`
- lists: `list()`, `nonempty_list()`, maps: `map()`
- a value of any type: `any()`
- union `|`. For example, `integer() | :error`
- tuple of any size `tuple()`
- tuples with fixed size `{:ok, integer()}`

Some types can also be parameterized, for example `list(integer)` is a list of integers.

Literal values can also be used as types.

#### Naming function parameters
```elixir
@spec to_hex(hue :: integer, saturation :: integer, lightness :: integer) :: String.t()
def to_hex(hue, saturation, lightness)
```

#### User defined types
```elixir
@type color :: {hue :: integer, saturation :: integer, lightness :: integer}

@spec to_hex(color()) :: String.t()
def to_hex({hue, saturation, lightness})
```

## [Community Garden](./community-garden/README.md)

`Agent` module abstracts spawning processes with send-receive loop. Agents
encapsulate some mutable state.

```elixir
defmodule SendReceive do
  def loop(state) do
    receive do
      {:inc, sender} ->
        send(sender, :ok)
        loop(state + 1)

      {:get, sender} ->
        send(sender, state)
        loop(state)
    end
  end
end

pid = spawn(SendReceive, :loop, [42])

send(pid, {:inc, self})
receive do
  msg -> msg
end #=> :ok

send(pid, {:get, self})
receive do
  msg -> msg
end #=> 43
```

Or the equivalent code with `Agent`

```elixir
{:ok, pid} = Agent.start(fn -> 42 end)

Agent.cast(pid, &(&1 + 1)) #=> :ok
Agent.get(pid, &(&1)) #=> 43
```

## [Need for speed](./need-for-speed/README.md)

```elixir
defmodule A.B.C do
  def test, do: 42
end

defmodule MyModule do
  alias A.B.C # makes C.test available in this module
  alias Integer, as: I # makes functions from Integer module available with I
  # e.g. I.digits, I.pow, I.gcd, etc
  import Float # makes ALL functions from Float available without prefix
  import Date, except: [new: 4] # import ALL functions from Date except new/4
  import String, only: [graphemes: 1] # makes graphemes/1 from String available
  # without prefix
end
```

## [Variable Length Quantity](./variable-length-quantity/README.md)

## [Top Secret](./top-secret/README.md)

AST also called a quoted expression in Elixir represents a piece of code, it
is used for metaprogramming. `Code` and `Macro` modules are used to manipulate
AST.

```elixir
quote do
  2 + 3
end
#=> {
#  :+,
#  [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
#  [2, 3]
# }
```
So tuple returned by `quote` special form consist of an atom, the operation,
a keyword list, the metadata, and a list of arguments, which contains other nodes.

## [Basketball Website](./basketball-website/README.md)

### Behaviours

Behaviours can be referenced by modules to ensure they implement required specific function signatures defined by @callback.

```elixir
defmodule Person do
  @behaviour Access
end
# warning: function fetch/2 required by behaviour Access is not implemented (in module Person)
# warning: function get_and_update/3 required by behaviour Access is not implemented (in module Person)
# warning: function pop/2 required by behaviour Access is not implemented (in module Person)

defmodule Person do
  @behaviour Access

  defstruct [:name, :age]

  @impl Access
  def fetch(%Person{name: name}, :name), do: {:ok, name}
  def fetch(%Person{age: age}, :age), do: {:ok, age}
  def fetch(_, _), do: :error

  @impl Access
  def get_and_update(%Person{name: old_name, age: age}, :name, fun) do
    case fun.(old_name) do
      :pop -> {old_name, %Person{age: age}}
      {old_name, new_name} -> {old_name, %Person{name: new_name, age: age}}
    end
  end
  def get_and_update(%Person{name: name, age: old_age}, :age, fun) do
    case fun.(old_age) do
      :pop -> {old_age, %Person{name: name}}
      {old_age, new_age} -> {old_age, %Person{name: name, age: new_age}}
    end
  end
  def get_and_update(%Person{} = person, _key, _fun) do
    {nil, person}
  end

  @impl Access
  def pop(%Person{age: age}, :name), do: %Person{age: age}
  def pop(%Person{name: name}, :age), do: %Person{name: name}
  def pop(%Person{} = person, _key), do: person
end

p = %Person{name: "John", age: 30}
p[:age] #=> 30
Access.pop(p, :name) #=>  %Person{name: nil, age: 30}
Access.get_and_update(p, :age, fn current_value ->
  {current_value, current_value + 1}
end) #=> {30, %Person{name: "John", age: 31}}
```

## [Dancing Dots](./dancing-dots/README.md)

### `__using__` macro

`use` macro allows us to quickly extend our module with functionality provided
by another module by injecting code into our module, defining functions,
importing or aliasing other modules, or setting module attributes.

This injections defined in the module's `__using__/1` macro.
```elixir
defmodule ConstMethods do
  defmacro __using__(opts) do
    Enum.map(opts, fn {key, value} ->
      quote do
        def unquote(key)() do
          unquote value
        end
      end
    end)
  end
end

defmodule TestMe do
  use ConstMethods, [pi: 3.14, g: 9.81, e: 2.71]
end

TestMe.pi #=> 3.14
TestMe.g #=> 9.81
TestMe.e #=> 2.71
```

### Behaviours

See [Basketball Website](#Basketball-Website)

Provide default callbacks implementation with `__using__/1`.

Note that defining functions inside of `__using__/1` is discouraged
for any other purpose than defining default callback implementations,
but you can always define functions in another module and import them
in the `__using__/1` macro.

To make it possible for users of the behaviour module to override
the default implementation, call the defoverridable/1 macro
after the function implementation

```elixir
defmodule Countable do
  @callback count(collection :: any) :: pos_integer

  defmacro __using__(_) do
    quote do
      @behaviour Countable
      def count(collection), do: Enum.count(collection)
      defoverridable count: 1
    end
  end
end
```

## [Take-A-Number Deluxe](./take-a-number-deluxe/README.md)

`GenServer` (generic server) is a behaviour that abstracts common
client-server interactions between Elixir processes.
`GenServer` behaviour provides abstractions for implementing send-receive loops.

The `GenServer` behaviour defines one required callback, `init/1`,
and a few interesting optional callbacks: `handle_call/3`, `handle_cast/2`,
and `handle_info/3`. The clients using a `GenServer` aren't supposed to call
those callbacks directly. Instead, the `GenServer` module provides functions
that clients can use to communicate with a GenServer process.

Often, a single module defines both a client API, a set of functions
that other parts of your Elixir app can call to communicate
with this `GenServer` process, and server callback implementations,
which contain this `GenServer`'s logic.

Typical `GenServer` usage:

```elixir
defmodule MyStack do
  use GenServer

  # Client API

  @spec start_link() :: GenServer.on_start()
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  @spec push(pid(), any()) :: nil
  def push(stack, item) do
    GenServer.cast(stack, {:push, item})
  end

  @spec pop(pid()) :: {:ok, any()} | {:error, String.t()}
  def pop(stack) do
    GenServer.call(stack, :pop)
  end

  # Callbacks

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  @impl true
  def handle_call(:pop, _, state) do
    case state do
      [] -> {:reply, {:error, "Cannot pop from empty stack"}, state}
      [top | rest] -> {:reply, {:ok, top}, rest}
    end
  end
end

{:ok, my_stack} = MyStack.start_link()
Stack.push(stack, 1) #=> :ok
Stack.pop(stack) #=> {:ok, 1}
Stack.pop(stack) #=> {:error, "Cannot pop from empty stack"}
```
