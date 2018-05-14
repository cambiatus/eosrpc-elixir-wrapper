defmodule EOSRPC.History do
  @moduledoc """
  EOS History Apis Wrapper for Elixir
  """

  import EOSRPC

  @doc """
  Retrieve a transaction from the blockchain.
  """
  def get_transaction(id) do
    "/get_transaction" |> url() |> post_request(%{id: id})
  end

  @doc """
  Get actions for a given account
  """
  def get_actions(account_name, pos \\ 0, offset \\ 100) do
    "/get_actions"
    |> url()
    |> post_request(%{account_name: account_name, pos: pos, offset: offset})
  end

  def url(url),
    do:
      :eosrpc
      |> Application.get_env(__MODULE__)
      |> Keyword.get(:url)
      |> Kernel.<>(url)
end
