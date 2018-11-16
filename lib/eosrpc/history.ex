defmodule EOSRPC.History do
  @moduledoc """
  EOS History Apis Wrapper for Elixir
  """

  @callback get_transaction(id :: any) :: any
  @callback get_actions(account_name :: binary, post :: integer, offset :: integer) :: any
  @callback url(url :: binary) :: binary

  use Tesla

  import EOSRPC

  plug(Tesla.Middleware.JSON)
  plug(EOSRPC.Middleware.Error)

  @doc """
  Retrieve a transaction from the blockchain.
  """
  def get_transaction(transaction_id) do
    "/get_transaction" |> url() |> post(%{id: transaction_id})
  end

  def get_transaction!(transaction_id) do
    unwrap_or_raise(get_transaction(transaction_id))
  end

  @doc """
  Get actions for a given account
  """
  def get_actions(account_name, pos \\ 0, offset \\ 10_000) do
    "/get_actions"
    |> url()
    |> post(%{account_name: account_name, pos: pos, offset: offset})
  end

  def get_actions!(account_name, pos \\ 0, offset \\ 10_000) do
    unwrap_or_raise(get_actions(account_name, pos, offset))
  end

  @doc """
  Retrieve accounts associated with a public key
  """
  def get_key_accounts(public_key) do
    "/get_key_accounts" |> url() |> post(%{public_key: public_key})
  end

  def get_key_accounts!(public_key) do
    unwrap_or_raise(get_key_accounts(public_key))
  end

  @doc """
  Retrieve accounts which are created by the given account
  """
  def get_controlled_accounts(account_name) do
    "/get_controlled_accounts"
    |> url()
    |> post(%{controlling_account: account_name})
  end

  def get_controlled_accounts!(account_name) do
    unwrap_or_raise(get_controlled_accounts(account_name))
  end

  def url(url) do
      :eosrpc
      |> Application.get_env(__MODULE__)
      |> Keyword.get(:url)
      |> Kernel.<>(url)
  end
end
