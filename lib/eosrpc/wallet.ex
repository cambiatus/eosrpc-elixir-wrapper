defmodule EOSRPC.Wallet do
  @moduledoc """
  EOSRPC Wallet Wrapper for Elixir

  Based on: https://eosio.github.io/eos/group__eosiorpc.html#walletrpc
  """

  import EOSRPC

  use Tesla

  plug(Tesla.Middleware.BaseUrl, base_url())
  plug(Tesla.Middleware.JSON)

  def list, do: get_request("/list_wallets")

  def lock_all, do: get_request("/lock_all")

  def get_public_keys, do: get_request("/get_public_keys")

  def list_keys, do: get_request("/list_keys")

  def create(name), do: post_request("/create", name, true)

  def open(name), do: post_request("/open", name, true)

  def lock(name), do: post_request("/lock", name, true)

  def unlock(name, password) do
    post_request("/unlock", [name, password])
  end

  def import_key(name, key) do
    post_request("/import_key", [name, key])
  end

  def set_timeout(timeout), do: post_request("/set_timeout", timeout)

  def sign_transaction(
        ref_block_num,
        ref_block_prefix,
        expiration,
        scope,
        read_scope,
        messages,
        signatures,
        keys,
        unknown
      ) do
    # TODO: whats this unknown parameter?

    data = [
      %{
        ref_block_num: ref_block_num,
        ref_block_prefix: ref_block_prefix,
        expiration: expiration || one_minute_from_now(),
        scope: scope,
        read_scope: read_scope || [],
        messages: messages,
        signatures: signatures || []
      },
      keys,
      unknown || ""
    ]

    post_request("/sign_transaction", data)
  end

  def one_minute_from_now do
    Timex.now()
    |> Timex.shift(minutes: 1)
    |> Timex.format!("%FT%T", :strftime)
  end

  def base_url(), do: :eosrpc |> Application.get_env(__MODULE__) |> Keyword.get(:url)
end
