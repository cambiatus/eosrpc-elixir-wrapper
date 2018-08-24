defmodule EOSRPC do
  @moduledoc """
  EOSRPC Wrapper for Elixir

  Based on: https://eosio.github.io/eos/group__eosiorpc.html

  See the functions on modules `EOSRPC.Wallet` and `EOSRPC.Chain`

  There's also a helper module that has functions to basic scenarios as
  easy transaction push and account creation: `EOSRPC.Helper`
  """

  @doc """
  Macro that "bangify" functions, and normalize the exception throws when returning status tuples: `{:ok, value}` and `{:error, reason}`

  ### Usage
  ```
  defmodule X do
    import EOSRPC

    def normal(param) do
      if param == 1 do
        {:ok, param + 1}
      else
        {:error, "not one"}
      end
    end

    def normal!() do
      unwrap_or_raise(normal())
    end
  end
  ```
  """
  defmacro unwrap_or_raise(call) do
    quote do
      case unquote(call) do
        {:ok, value} -> value
        {:error, env} -> raise EOSRPC.Error, reason: env.body, url: env.url
      end
    end
  end
end
