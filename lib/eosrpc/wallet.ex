defmodule EOSRPC.Wallet do
  @moduledoc """
  EOSRPC Wallet Wrapper for Elixir

  Based on: https://eosio.github.io/eos/group__eosiorpc.html#walletrpc
  """

  import EOSRPC

  @doc """
  List all wallets
  """
  def list, do: "/list_wallets" |> url() |> get_request()

  @doc """
  Lock all wallets
  """
  def lock_all, do: "/lock_all" |> url() |> get_request()

  @doc """
  List all public keys across all wallets
  """
  def get_public_keys, do: "/get_public_keys" |> url() |> get_request()

  @doc """
  List all key pairs across all wallets
  """
  def list_keys, do: "/list_keys" |> url() |> get_request()

  @doc """
  Create a new wallet with the given name
  """
  def create(name), do: "/create" |> url() |> post_request(name, true)

  @doc """
  Open an existing wallet of the given name
  """
  def open(name), do: "/open" |> url() |> post_request(name, true)

  @doc """
  Lock a wallet of the given name
  """
  def lock(name), do: "/lock" |> url() |> post_request(name, true)

  @doc """
  Unlock a wallet with the given name and password
  """
  def unlock(name, password) do
    "/unlock"
    |> url()
    |> post_request([name, password])
  end

  @doc """
  Import a private key to the wallet of the given name
  """
  def import_key(name, key) do
    "/import_key"
    |> url()
    |> post_request([name, key])
  end

  @doc """
  Set wallet auto lock timeout (in seconds)
  """
  def set_timeout(timeout_secs), do: "/set_timeout" |> url() |> post_request(timeout_secs)

  @doc """
  Sign transaction given an array of transaction, require public keys, and chain id

  `transaction` structure should be a map like this json:

  ```
  {
    "signatures": [],
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

  `keys` should be a list of public keys

  """
  def sign_transaction(transaction, keys), do: sign_transaction(transaction, keys, "")

  def sign_transaction(transaction, keys, chain_id) do
    "/sign_transaction"
    |> url()
    |> post_request([transaction, keys, chain_id])
  end

  def url(url),
    do: :eosrpc |> Application.get_env(__MODULE__) |> Keyword.get(:url) |> Kernel.<>(url)
end
