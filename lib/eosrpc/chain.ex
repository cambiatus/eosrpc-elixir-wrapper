defmodule EOSRPC.Chain do
  @moduledoc """
  EOSRPC Wallet Wrapper for Elixir

  Based on: https://eosio.github.io/eos/group__eosiorpc.html#chainrpc
  """

  import EOSRPC

  @doc """
  Get latest information related to a node
  """
  def get_info, do: url("/get_info") |> get_request()

  @doc """
  Get information related to a block.
  """
  def get_block(block_num_or_id) do
    "/get_block" |> url() |> post_request(%{block_num_or_id: block_num_or_id})
  end

  @doc """
  Get information related to an account.
  """
  def get_account(account_name) do
    "/get_account" |> url() |> post_request(%{account_name: account_name})
  end

  @doc """
  Fetch smart contract code.
  """
  def get_code(account_name) do
    "/get_code" |> url() |> post_request(%{account_name: account_name})
  end

  @doc """
  Fetch smart contract data from an account.
  """
  def get_table_rows(contract, scope, table, json) do
    data = %{
      scope: scope,
      code: contract,
      table: table,
      json: json
    }

    "/get_table_rows" |> url() |> post_request(data)
  end

  @doc """
  Get required keys to sign a transaction from list of your keys.
  """
  def get_required_keys(transaction_data, available_keys) do
    data = %{
      transaction: transaction_data,
      available_keys: available_keys
    }

    "/get_required_keys" |> url() |> post_request(data)
  end

  @doc """
  Serialize json to binary hex. The resulting binary hex is usually used
  for the data field in push_transaction.
  """
  def abi_json_to_bin(code, action, args) do
    "/abi_json_to_bin" |> url() |> post_request(%{code: code, action: action, args: args})
  end

  @doc """
  Serialize back binary hex to json.
  """
  def abi_bin_to_json(code, action, binargs) do
    "/abi_bin_to_json" |> url() |> post_request(%{code: code, action: action, binargs: binargs})
  end

  @doc """
  This method expects a transaction in JSON format and will attempt to apply it to the blockchain,

  `signed_transaction` should be a map like this JSON:

  ```
  {
    "signatures": [
      "EOSKZ4pTehVfqs92wujRp34qRAvUjKJrUyufZfJDo9fdBLzhieyfUSUJpKz1Z12rxh1gTQZ4BcWvKourzxCLb2fMsvN898KSn"
    ],
    "compression": "none",
    "context_free_data": [],
    "transaction": {
      "region": 0,
      "ref_block_num": "32697",
      "ref_block_prefix": "32649",
      "expiration": "2018-09-25T06:28:49",
      "max_net_usage_words": 0,
      "max_kcpu_usage": 0,
      "delay_sec": 0,
      "context_free_actions": [],
      "actions": [
        {
          "account": "eoseco",
          "name": "transfer",
          "authorization": [
            {
              "actor": "eoseco",
              "permission": "active"
            }
          ],
          "data": "0000000050a430550000000000003ab60a000000000000000045434f0000000000"
        }
      ]
    }
  }
  ```
  """
  def push_transaction(signed_transaction) do
    "/push_transaction" |> url() |> post_request(signed_transaction)
  end

  def push_transactions(signed_transactions) do
    "/push_transactions" |> url() |> post_request(signed_transactions)
  end

  def url(url),
    do:
      :eosrpc
      |> Application.get_env(__MODULE__)
      |> Keyword.get(:url)
      |> Kernel.<>(url)
end
