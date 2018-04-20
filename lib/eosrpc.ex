defmodule EOSRPC do
  @moduledoc """
  EOSRPC Wrapper for Elixir

  Based on: https://eosio.github.io/eos/group__eosiorpc.html
  """

  def validate_request(response) do
    case response.status do
      s when s in [200, 201, 203, 204] -> {:ok, response.body}
      _ -> {:error, response}
    end
  end

  def quotify(raw_data) do
    if !!raw_data do
      ~s("#{raw_data}")
    else
      raw_data
    end
  end
end
