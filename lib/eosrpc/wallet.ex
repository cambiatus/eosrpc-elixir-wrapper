defmodule EOSRPC.Wallet do
  @moduledoc """
  EOSRPC Wallet Wrapper for Elixir

  Based on source code, since there is no documentation for this
  https://github.com/EOSIO/eos/blob/master/plugins/wallet_api_plugin/wallet_api_plugin.cpp
  """

  use Tesla

  import EOSRPC

  plug(EOSRPC.Middleware.Error)
  plug(Tesla.Middleware.JSON)

  @doc """
  List all wallets
  """
  def list, do: "/list_wallets" |> url() |> get()
  def list!, do: unwrap_or_raise(list())

  @doc """
  Lock all wallets
  """
  def lock_all, do: "/lock_all" |> url() |> get()
  def lock_all!, do: unwrap_or_raise(lock_all())

  @doc """
  List all public keys across all wallets
  """
  def get_public_keys, do: "/get_public_keys" |> url() |> get()
  def get_public_keys!, do: unwrap_or_raise(get_public_keys())

  @doc """
  List all key pairs across all wallets
  """
  def list_keys, do: "/list_keys" |> url() |> get()
  def list_keys!, do: unwrap_or_raise(list_keys())

  @doc """
  Create a new wallet with the given name
  """
  def create(name), do: "/create" |> url() |> post(name, true)
  def create!(name), do: unwrap_or_raise(create(name))

  @doc """
  Open an existing wallet of the given name
  """
  def open(name), do: "/open" |> url() |> post(name, true)
  def open!(name), do: unwrap_or_raise(open(name))

  @doc """
  Lock a wallet of the given name
  """
  def lock(name), do: "/lock" |> url() |> post(name, true)
  def lock!(name), do: unwrap_or_raise(lock(name))

  @doc """
  Unlock a wallet with the given name and password
  """
  def unlock(name, password) do
    "/unlock"
    |> url()
    |> post([name, password])
  end
  def unlock!(name, password), do: unwrap_or_raise(unlock(name, password))

  @doc """
  Import a private key to the wallet of the given name
  """
  def import_key(name, key) do
    "/import_key"
    |> url()
    |> post([name, key])
  end
  def import_key!(name, key), do: unwrap_or_raise(import_key(name, key))

  @doc """
  Set wallet auto lock timeout (in seconds)
  """
  def set_timeout(seconds), do: "/set_timeout" |> url() |> post(seconds)
  def set_timeout!(seconds), do: unwrap_or_raise(set_timeout(seconds))

  @doc """
  Sign transaction given an array of transaction, require public keys, and chain id

  `transaction` structure like this json:

  ```
  {
    "signatures": [],
    "compression": "none",
    "transaction": {
      "context_free_actions": [],
      "delay_sec": 0,
      "expiration": "2018-09-25T06:28:49",
      "max_cpu_usage_ms": 0,
      "net_usage_words": 0,
      "ref_block_num": 32697,
      "ref_block_prefix": 32649123,
      "transaction_extensions": []
      "actions": [
        {
          "account": "eosio",
          "name": "transfer",
          "authorization": [
            {
              "actor": "eosio",
              "permission": "active"
            }
          ],
          "data": "0000000050a430550000000000003ab60a000000000000000045434f0000000000"
        }
      ]
    }
  }
  ```

  `keys` a list of public keys
  `chain_id` the chain id, a field from chain_info

  """
  def sign_transaction(transaction, keys), do: sign_transaction(transaction, keys, "")
  def sign_transaction!(transaction, keys), do: unwrap_or_raise(sign_transaction(transaction, keys))

  def sign_transaction(transaction, keys, chain_id) do
    "/sign_transaction"
    |> url()
    |> post([transaction, keys, chain_id])
  end
  def sign_transaction!(transaction, keys, chain_id) do
    unwrap_or_raise(sign_transaction(transaction, keys, chain_id))
  end

  def url(url),
    do:
      :eosrpc
      |> Application.get_env(__MODULE__)
      |> Keyword.get(:url)
      |> Kernel.<>(url)
end
