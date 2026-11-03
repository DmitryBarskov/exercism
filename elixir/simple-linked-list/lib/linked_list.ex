defmodule LinkedList do
  defstruct [:value, :length, :rest]

  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    %LinkedList{value: nil, length: 0, rest: nil}
  end

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(%LinkedList{length: length} = rest, elem) do
    %LinkedList{value: elem, length: length + 1, rest: rest}
  end

  @doc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count(list) do
    list.length
  end

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(list) do
    list.length == 0
  end

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek(list) do
    if list.length > 0 do
      {:ok, list.value}
    else
      {:error, :empty_list}
    end
  end

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail(list) do
    if list.length > 0 do
      {:ok, list.rest}
    else
      {:error, :empty_list}
    end
  end

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop(list) do
    if list.length > 0 do
      {:ok, list.value, list.rest}
    else
      {:error, :empty_list}
    end
  end

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list([]), do: LinkedList.new()

  def from_list([x | xs]) do
    rest = from_list(xs)
    %LinkedList{value: x, length: rest.length + 1, rest: rest}
  end

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(%LinkedList{length: 0}), do: []

  def to_list(list) do
    [list.value | to_list(list.rest)]
  end

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: reverse(list, LinkedList.new())

  defp reverse(%LinkedList{length: 0}, acc), do: acc

  defp reverse(list, acc) do
    reverse(
      list.rest,
      %LinkedList{value: list.value, length: acc.length + 1, rest: acc}
    )
  end
end
