defmodule TestTeslaTest do
  use ExUnit.Case
  doctest TestTesla

  test "greets the world" do
    assert TestTesla.hello() == :world
  end
end
