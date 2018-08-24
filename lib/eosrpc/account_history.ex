defmodule EOSRPC.AccountHistory do
  @moduledoc """
  EOS Account History Apis Wrapper for Elixir

  Based on: https://developers.eos.io/eosio-nodeos/reference on History section
  """

  use Tesla

  import EOSRPC

  plug(Tesla.Middleware.JSON)
  plug(EOSRPC.Middleware.Error)


  @doc """
  Gets all actions for a given account
  """
  def get_actions(account_name) do
    "get_actions" |> url() |> post(%{account_name: account_name})
  end

  def get_actions!(account_name) do
    unwrap_or_raise(get_actions(account_name))
  end

  @doc """
  Get transaction data
  """
  def get_transaction(transaction_id) do
    "/get_transaction" |> url() |> post(%{transaction_id: transaction_id})
  end

  def get_transaction!(transaction_id) do
    unwrap_or_raise(get_transaction(transaction_id))
  end

  @doc """
  Get transactions for a given account
  """
  def get_transactions(account_name) do
    "/get_transactions" |> url() |> post(%{account_name: account_name})
  end

  def get_transactions!(account_name) do
    unwrap_or_raise(get_transactions(account_name))
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

  def url(url),
    do:
      :eosrpc
      |> Application.get_env(__MODULE__)
      |> Keyword.get(:url)
      |> Kernel.<>(url)
end
