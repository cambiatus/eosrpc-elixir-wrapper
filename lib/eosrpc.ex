defmodule EOSRPC do
  @moduledoc """
  EOSRPC Wrapper for Elixir

  Based on: https://eosio.github.io/eos/group__eosiorpc.html

  See the functions on modules `EOSRPC.Wallet` and `EOSRPC.Chain`

  There's also a helper module that has functions to basic scenarios as
  easy transaction push and account creation: `EOSRPC.Helper`
  """

  use Tesla

  plug(Tesla.Middleware.JSON)

  def get_request(url) do
    url
    |> get!()
    |> validate_request()
  end

  def post_request(url, raw_data, quotify) do
    data = if quotify, do: quotify(raw_data), else: raw_data

    url
    |> post!(data)
    |> validate_request()
  end

  def post_request(url, raw_data) do
    post_request(url, raw_data, false)
  end

  def validate_request(response) do
    case response.status do
      s when s in [200, 201, 202, 203, 204] -> {:ok, response.body}
      _ -> {:error, response}
    end
  end

  def quotify(nil), do: nil
  def quotify(raw_data), do: ~s("#{raw_data}")
end
