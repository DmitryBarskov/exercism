defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts()) :: {:ok, opts()} | {:error, error()}

  @callback handle_frame(dot(), frame_number(), opts()) :: dot()

  defmacro __using__(_opts) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation
  import Integer, only: [mod: 2]
  alias DancingDots.Dot

  @impl DancingDots.Animation
  def handle_frame(%Dot{opacity: opacity} = dot, frame_number, _opts) do
    if mod(frame_number, 4) == 0 do
      %Dot{dot | opacity: opacity / 2}
    else
      dot
    end
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation
  alias DancingDots.Dot

  @impl DancingDots.Animation
  def init(opts) do
    case opts[:velocity] do
      v when is_number(v) ->
        {:ok, opts}

      velocity ->
        {
          :error,
          "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"
        }
    end
  end

  @impl DancingDots.Animation
  def handle_frame(%Dot{radius: radius} = dot, frame_number, opts) do
    %Dot{dot | radius: radius + (frame_number - 1) * opts[:velocity]}
  end
end
