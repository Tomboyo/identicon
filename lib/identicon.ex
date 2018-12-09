defmodule Identicon do
  alias Identicon.Image

  def main(input) do
    input
    |> hash_input()
    |> Image.from_bytes()
    |> create_image()
    |> save_image(input)
  end

  # MD5 hashes are always 128 bits (16 bytes) long
  @spec hash_input(String.t) :: [byte]
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()
  end

  @spec create_image(Image.t) :: binary()
  def create_image(image) do
    canvas = :egd.create(250, 250)
    fill = :egd.color(image.color)

    image.grid
    |> Enum.each(fn index ->
      :egd.filledRectangle(canvas, start(index), finish(index), fill)
    end)

    :egd.render(canvas)
  end

  defp start(index) do
    y = div(index, 5) * 50
    x = rem(index, 5) * 50
    {x, y}
  end

  defp finish(index) do
    {origin_x, origin_y} = start(index)
    {origin_x + 50, origin_y + 50}
  end

  @spec save_image(binary, String.t) :: :ok | {:error, atom}
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end
end
