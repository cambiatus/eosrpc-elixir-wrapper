defmodule EOSRPC.Chain do
  @moduledoc """
  EOSRPC Wallet Wrapper for Elixir

  Based on: https://eosio.github.io/eos/group__eosiorpc.html#chainrpc
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, base_url())
  plug(Tesla.Middleware.JSON)

  defp base_url(), do: Application.get_env(:eosrpc, :chain)

  defp get_request(url) do
    get!(url)
    |> EOSRPC.validate_request
  end

  defp post_request(url, raw_data, quotify) do
    data = if quotify, do: EOSRPC.quotify(raw_data), else: raw_data
    post!(url, data)
    |> EOSRPC.validate_request
  end

  def get_info() do
    get_request("/get_info")
  end

end