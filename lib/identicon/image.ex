defmodule Identicon.Image do
  require Integer

  @enforce_keys [:grid, :color]
  defstruct [:grid, :color]
  alias Identicon.Image
  @type grid :: [ {integer} ]
  @type color :: { byte, byte, byte }
  @type t :: %__MODULE__{ grid: grid, color: color }

  @spec from_bytes([byte]) :: t
  def from_bytes(bytes) do
    %Image{
      grid: grid_from(bytes),
      color: color_from(bytes)
    }
  end

  @spec grid_from([byte]) :: grid
  defp grid_from(bytes) do
    bytes
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.flat_map(&mirror_row/1)
    |> Enum.with_index
    |> Enum.filter(fn {hex, _} -> Integer.is_even(hex) end)
    |> Enum.map(&elem(&1, 1))
  end

  @spec mirror_row([byte]) :: [byte]
  defp mirror_row([a, b, c]) do
    [a, b, c, b, a]
  end

  @spec color_from([byte]) :: color
  defp color_from([r, g, b | _]) do
    { r, g, b }
  end
end
