defmodule EOSRPC.Wallet do
  @moduledoc """
  EOSRPC Wallet Wrapper for Elixir

  Based on: https://eosio.github.io/eos/group__eosiorpc.html#walletrpc
  """

  use Tesla

  plug(Tesla.Middleware.BaseUrl, base_url())
  plug(Tesla.Middleware.JSON)

  defp base_url(), do: Application.get_env(:eosrpc, :wallet)

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

  def list() do
    get_request("/list_wallets")
  end

  def lock_all() do
    get_request("/lock_all")
  end

  def get_public_keys() do
    get_request("/get_public_keys")
  end

  def list_keys() do
    get_request("/list_keys")
  end

  def create(name) do
    post_request("/create", name, true)
  end

  def open(name) do
    post_request("/open", name, true)
  end

  def lock(name) do
    post_request("/lock", name, true)
  end

  def unlock(name, password) do
    post_request("/unlock", [name, password])
  end

  def import_key(name, key) do
    post_request("/import_key", [name, key])
  end

  def set_timeout(timeout) do
    post_request("/set_timeout", timeout)
  end

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
    #    TODO: whats this unknown parameter?

    time =
      if !!expiration do
        expiration
      else
        Timex.now()
        |> Timex.shift(minutes: 1)
        |> Timex.format!("%FT%T", :strftime)
      end

    data = [
      %{
        ref_block_num: ref_block_num,
        ref_block_prefix: ref_block_prefix,
        expiration: time,
        scope: scope,
        read_scope: if(!!read_scope, do: read_scope, else: []),
        messages: messages,
        signatures: if(!!signatures, do: signatures, else: [])
      },
      keys,
      if(!!unknown, do: unknown, else: "")
    ]

    post_request("/sign_transaction", data)
  end
end
