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
          {:ok, bin} ->
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
  def sign_transaction(trx_data) do
    {:ok, public_keys} = Wallet.get_public_keys()

    {:ok, keys} = Chain.get_required_keys(trx_data, public_keys)

    Wallet.sign_transaction(trx_data, keys["required_keys"])
  end

  @doc """
  Push transaction data with the signature found on `sign_transaction/1`
  """
  def push_transaction(trx_data, signatures) do
    final_trx_data = %{
      signatures: signatures,
      compression: "none",
      context_free_data: [],
      transaction: trx_data
    }

    Chain.push_transaction(final_trx_data)
  end

  @doc """
  Get the current irreversible block data from the chain
  """
  def current_irreversible_block do
    {:ok, chain} = Chain.get_info()
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
      accounts: []
    }

    active = %{
      threshold: 1,
      keys: [%{key: active_key, weight: 1}],
      accounts: []
    }

    recovery = %{
      threshold: 1,
      keys: [],
      accounts: [
        %{
          permission: %{
            actor: creator,
            permission: "active"
          },
          weight: 1
        }
      ]
    }

    action = %{
      account: "eosio",
      name: "newaccount",
      authorization: [authorization],
      data: %{
        creator: creator,
        name: new_account,
        active: active,
        owner: owner,
        recovery: recovery
      }
    }

    auto_push([action])
  end

  @doc """
  Sign and submit transaction if you have binary data, otherwise utilizes `auto_push/1`
  """
  def auto_push_bin(actions) do
    {:ok, block} = current_irreversible_block()

    trx_data = %{
      ref_block_num: block["block_num"],
      ref_block_prefix: block["ref_block_prefix"],
      expiration: one_minute_from_now(),
      region: 0,
      max_net_usage_words: 0,
      max_kcpu_usage: 0,
      delay_sec: 0,
      context_free_actions: [],
      actions: actions
    }

    case sign_transaction(trx_data) do
      {:ok, sign_body} -> push_transaction(trx_data, sign_body["signatures"])
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
