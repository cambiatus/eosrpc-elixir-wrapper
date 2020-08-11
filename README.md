# EOSRPC

[![Build Status](https://travis-ci.org/BeSpiral/eosrpc-elixir-wrapper.svg?branch=master)](https://travis-ci.org/BeSpiral/eosrpc-elixir-wrapper)
[![Hex.pm](https://img.shields.io/hexpm/v/eosrpc.svg)](https://hex.pm/packages/eosrpc)


Simple EOSRPC Wrapper for Elixir.
Based on [EOS RPC Official Docs](https://developers.eos.io/eosio-nodeos/reference)

## Installation

```elixir
def deps do
  [
    {:eosrpc, "~> 0.6.0"}
  ]
end
```

You need to setup the Chain, Wallet and Account History URLs. This is the default configuration:


```elixir
config :eosrpc, EOSRPC.Wallet,
  url: "http://127.0.0.1:8999/v1/wallet"

config :eosrpc, EOSRPC.Chain,
  url: "http://127.0.0.1:8888/v1/chain"

config :eosrpc, EOSRPC.History,
  url: "http://127.0.0.1:8888/v1/history"
```


## Examples

Autosigning and pushing a transaction.

```elixir
actions = [
  %{
    account: "eosio.token",
    authorization: [%{actor: "eosio.token", permission: "active"}],
    data: %{issuer: "eosio", max_supply: "10000.00 LEO"},
    name: "create"
  }
]

EOSRPC.Helper.auto_push(actions)
```

Creating a new account `leo` under the owner `eosio`

```elixir
EOSRPC.Helper.new_account("eosio", "leo", "EOS_OWNER_PUB_KEY", "EOS_ACTIVE_PUB_KEY")
```

All of the EOSRPC APIs are in `EOSRPC.Wallet`, `EOSRPC.Chain` and `EOSRPC.History`

For complete transactions signature and submission flow examples check `EOSRPC.Helper`

## License

This project is licensed under the GNU GPLv3 License - see the [LICENSE](LICENSE) file for details
