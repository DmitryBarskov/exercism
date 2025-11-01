defmodule FileSniffer do
  def type_from_extension("exe"), do: "application/octet-stream"
  def type_from_extension("bmp"), do: "image/bmp"
  def type_from_extension("png"), do: "image/png"
  def type_from_extension("jpg"), do: "image/jpg"
  def type_from_extension("gif"), do: "image/gif"
  def type_from_extension(_), do: nil

  def type_from_binary(<<0x7F454C46::32, _::binary>>), do: "application/octet-stream"
  def type_from_binary(<<0x42, 0x4D, _::binary>>), do: "image/bmp"
  def type_from_binary(<<0x89504E470D0A1A0A::64, _::binary>>), do: "image/png"
  def type_from_binary(<<0xFF, 0xD8, 0xFF, _::binary>>), do: "image/jpg"
  def type_from_binary(<<0x47, 0x49, 0x46, _::binary>>), do: "image/gif"
  def type_from_binary(_), do: nil

  def verify(file_binary, extension) do
    actual_type = type_from_binary(file_binary)

    case type_from_extension(extension) do
      ^actual_type when not is_nil(actual_type) -> {:ok, actual_type}
      _ -> {:error, "Warning, file format and file extension do not match."}
    end
  end
end
