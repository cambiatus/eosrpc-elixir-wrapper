# EOSRPC

Simple EOSRPC Wrapper for Elixir. 
Based on [EOS RPC Official Docs](https://eosio.github.io/eos/group__eosiorpc.html)

For real examples check EOSRPC.Helper - You can also use it on your 
application to create accounts and automatically sign transactions.

## Installation

```elixir
def deps do
  [
    {:eosrpc, "~> 0.1.0"}
  ]
end
```

You need to setup the Chain and Wallet URLs. This is the default configuration:

```elixir
config :eosrpc, EOSRPC.Wallet,
  url: "http://127.0.0.1:8999/v1/wallet"

config :eosrpc, EOSRPC.Chain,
  url: "http://127.0.0.1:8888/v1/chain"
```


