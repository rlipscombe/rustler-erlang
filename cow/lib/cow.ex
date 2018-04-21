defmodule Cow do
  @moduledoc """
  Documentation for Cow.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Cow.hello
      :world

  """
  def hello do
    :world
  end
end

defmodule Cow.Moo do
  use Rustler, otp_app: :cow, crate: :cow_moo
end
