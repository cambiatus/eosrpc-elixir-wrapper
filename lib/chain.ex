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
    url
    |> get!()
    |> EOSRPC.validate_request()
  end

  defp post_request(url, raw_data, quotify) do
    data = if quotify, do: EOSRPC.quotify(raw_data), else: raw_data

    url
    |> post!(data)
    |> EOSRPC.validate_request()
  end

  defp post_request(url, raw_data) do
    post_request(url, raw_data, false)
  end

  def get_info() do
    get_request("/get_info")
  end

  def get_block(block_num_or_id) do
    post_request("/get_block", %{block_num_or_id: block_num_or_id})
  end

  def get_account(account_name) do
    post_request("/get_account", %{account_name: account_name})
  end

  def get_code(account_name) do
    post_request("/get_code", %{account_name: account_name})
  end

  def get_table_rows(scope, code, table, json) do
    data = %{
      scope: scope,
      code: code,
      table: table,
      json: json
    }

    post_request("/get_table_rows", data)
  end

  def push_transaction(signed_transaction) do
    post_request("/push_transaction", signed_transaction)
  end

  def push_transactions(signed_transactions) do
    post_request("/push_transactions", signed_transactions)
  end

  def get_required_keys(signed_transaction) do
    post_request("/get_required_keys", signed_transaction)
  end

  def abi_json_to_bin(code, action, args) do
    post_request("/abi_json_to_bin", %{code: code, action: action, args: args})
  end

  def abi_bin_to_json(code, action, binargs) do
    post_request("/abi_bin_to_json", %{code: code, action: action, binargs: binargs})
  end
end
