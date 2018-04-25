defmodule EOSRPC.AccountHistory do
  @moduledoc """
  EOS Account History Apis Wrapper for Elixir
  """

  import EOSRPC

  @doc """
  Get transaction data
  """
  def get_transaction(transaction_id) do
    "/get_transaction" |> url() |> post_request(%{transaction_id: transaction_id})
  end

  @doc """
  Get transactions for a given account
  """
  def get_transactions(account_name) do
    "/get_transactions" |> url() |> post_request(%{account_name: account_name})
  end

  @doc """
  Retrieve accounts associated with a public key
  """
  def get_key_accounts(public_key) do
    "/get_key_accounts" |> url() |> post_request(%{public_key: public_key})
  end

  @doc """
  Retrieve accounts which are created by the given account
  """
  def get_controlled_accounts(account_name) do
    "/get_controlled_accounts" |> url() |> post_request(%{controlling_account: account_name})
  end

  def url(url),
    do:
      :eosrpc
      |> Application.get_env(__MODULE__)
      |> Keyword.get(:url)
      |> Kernel.<>(url)
end
