defmodule HCLParser do

  @doc """
  Parses a terraform file, and returns a map structure representing it.

  ## Parameters

    - content: String that represents the content of the terraform file.

  ## Examples

      iex> content = 'provider "google" {}'

      iex> HCLParser.parse(content)
      {:ok, %{"provider" => %{"google" => {}}}}

  """
  def parse(content) when is_bitstring(content), do: content |> String.to_charlist() |> parse()
  def parse(content) do
    with {:ok, tokens, _} <- :lexer.string(content) do
      :parser.parse(tokens)
    else
      err -> err
    end
  end
end
