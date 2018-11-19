defmodule EOSRPC.Helper do
  @moduledoc """
  Helper functions to most used EOS Blockchain actions

  You will want to use:
  `auto_push/1` to automatically sign, get the keys from wallet and push the transaction
  `new_account/4` to create accounts

  You can use everything else, they will help you with some default actions that you need
  on your daily basis
  """

  alias EOSRPC.Chain
  alias EOSRPC.Wallet

  @doc """
  Retrieves the next minute - used mostly for expiration dates of transactions
  """
  def one_minute_from_now do
    Timex.now()
    |> Timex.shift(minutes: 1)
    |> Timex.format!("%FT%T", :strftime)
  end

  @doc """
  Convert a list of actions to binary data (/chain/abi_json_to_bin)
  """
  def actions_to_bin(actions) do
    final_actions =
      actions
      |> Enum.map(fn i ->
        response = Chain.abi_json_to_bin(i[:account], i[:name], i[:data])

        case response do
          {:ok, %{body: bin}} ->
            %{i | data: bin["binargs"]}

          _ ->
            response
        end
      end)

    errors =
      final_actions
      |> Enum.filter(fn i ->
        case i do
          {:error, _} -> true
          _ -> false
        end
      end)

    if length(errors) > 0, do: {:error, errors}, else: {:ok, final_actions}
  end

  @doc """
  Identify the required keys for the transaction and sign with them
  """
  def sign_transaction(trx_data, chain_id) do
    {:ok, %{body: public_keys}} = Wallet.get_public_keys()

    {:ok, %{body: keys}} = Chain.get_required_keys(trx_data, public_keys)

    Wallet.sign_transaction(trx_data, keys["required_keys"], chain_id)
  end

  @doc """
  Push transaction data with the signature found on `sign_transaction/1`
  """
  def push_transaction(trx_data, signatures) do
    final_trx_data = %{
      compression: "none",
      signatures: signatures,
      transaction: trx_data
    }

    Chain.push_transaction(final_trx_data)
  end

  @doc """
  Get the current irreversible block data from the chain
  """
  def current_irreversible_block do
    {:ok, %{body: chain}} = Chain.get_info()
    Chain.get_block(chain["last_irreversible_block_num"])
  end

  @doc """
  Creates a new account - exactly like cleos
  """
  def new_account(creator, new_account, owner_key, active_key) do
    authorization = %{
      actor: creator,
      permission: "active"
    }

    owner = %{
      threshold: 1,
      keys: [%{key: owner_key, weight: 1}],
      accounts: [],
      waits: []
    }

    active = %{
      threshold: 1,
      keys: [%{key: active_key, weight: 1}],
      accounts: [],
      waits: []
    }

    actions = [
      %{
        account: "eosio",
        name: "newaccount",
        authorization: [authorization],
        data: %{
          creator: creator,
          name: new_account,
          active: active,
          owner: owner
        }
      }
    ]

    auto_push(actions)
  end

  @doc """
  Sign and submit transaction if you have binary data, otherwise utilizes `auto_push/1`
  """
  def auto_push_bin(actions) do
    {:ok, %{body: chain}} = Chain.get_info()
    {:ok, %{body: block}} = Chain.get_block(chain["last_irreversible_block_num"])

    trx_data = %{
      actions: actions,
      context_free_actions: [],
      delay_sec: 0,
      expiration: one_minute_from_now(),
      max_cpu_usage_ms: 0,
      net_usage_words: 0,
      ref_block_num: block["block_num"],
      ref_block_prefix: block["ref_block_prefix"],
      transaction_extensions: []
    }

    case sign_transaction(trx_data, chain["chain_id"]) do
      {:ok, %{body: sign_body}} -> push_transaction(trx_data, sign_body["signatures"])
      error -> error
    end
  end

  @doc """
  Convert action data to binary, identify required keys, sign and finally push transaction
  """
  def auto_push(actions) do
    case actions_to_bin(actions) do
      {:ok, final_actions} -> auto_push_bin(final_actions)
      error -> error
    end
  end
end
