defmodule RobotSimulator do
  @type robot() :: any()
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  defstruct [:direction, :position]

  @directions [:north, :east, :south, :west]
  @right %{north: :east, east: :south, south: :west, west: :north}
  @left %{north: :west, west: :south, south: :east, east: :north}
  @dir %{north: {0, 1}, east: {1, 0}, south: {0, -1}, west: {-1, 0}}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(_, pos)
      when not is_tuple(pos) or tuple_size(pos) != 2 or
             not is_integer(elem(pos, 0)) or not is_integer(elem(pos, 1)) do
    {:error, "invalid position"}
  end

  def create(dir, _) when dir not in @directions do
    {:error, "invalid direction"}
  end

  def create(direction, position) do
    %RobotSimulator{direction: direction, position: position}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, instructions) do
    Enum.reduce_while(
      instructions |> String.graphemes(),
      robot,
      fn instruction, %{direction: direction, position: position} = state ->
        case instruction do
          "R" ->
            {:cont, %{state | direction: @right[direction]}}

          "L" ->
            {:cont, %{state | direction: @left[direction]}}

          "A" ->
            {x, y} = position
            {dx, dy} = @dir[direction]
            {:cont, %{state | position: {x + dx, y + dy}}}

          _ -> {:halt, {:error, "invalid instruction"}}
        end
      end
    )
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(robot), do: robot.position
end
