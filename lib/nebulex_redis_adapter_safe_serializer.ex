defmodule NebulexRedisAdapterSafeSerializer do
  @moduledoc """
  Implementation of `NebulexRedisAdapter.Serializer` that decodes values in a secure manner:

  * prevents decoding data that may be used to attack the Erlang system
  * forbids executable terms, such as anonymous functions
  """

  use NebulexRedisAdapter.Serializer

  @impl true
  def decode_value(data, _opts) do
    if not is_nil(data) do
      # [:safe] explained in https://www.erlang.org/docs/17/man/erlang#binary_to_term-2
      Plug.Crypto.non_executable_binary_to_term(data, [:safe])
    end
  rescue
    ArgumentError -> data
  end
end
