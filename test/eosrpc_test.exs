defmodule EOSRPCTest do
  use ExUnit.Case
  doctest EOSRPC

  test "greets the world" do
    assert EOSRPC.hello() == :world
  end
end
