defmodule HCLParserTest do
  use ExUnit.Case
  doctest HCLParser

  test "greets the world" do
    assert HCLParser.hello() == :world
  end
end
