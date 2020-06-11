defmodule HCLParser do
  def parse(content) when is_bitstring(content), do: content |> String.to_charlist() |> parse()
  def parse(content) do
    with {:ok, tokens, _} <- :lexer.string(content) do
      :parser.parse(tokens)
    else
      err -> err
    end
  end
end
