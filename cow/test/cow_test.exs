defmodule CowTest do
  use ExUnit.Case
  doctest Cow

  test "greets the world" do
    assert Cow.hello() == :world
  end
end
