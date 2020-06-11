defmodule HCLParser do

  @moduledoc """
  Provides access to HCLParser parse method.
  """

  @doc """
  Parses a terraform file, and returns a map structure representing it.

  ## Parameters

    - content: String that represents the content of the terraform file.

  ## Examples

      iex> content = 'provider "google" {}' |>  HCLParser.parse
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
