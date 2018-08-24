defmodule EOSRPC.Middleware.ErrorTest do
  use ExUnit.Case, async: false

  defmodule VanillaClient do
    use Tesla

    adapter fn (env) ->
      case env.url do
        "/200" ->
          {:ok, %{env | status: 200, body: "Everything fine"}}

        "/500" ->
          {:ok, %{env | status: 500, body: "Uoh!"}}
      end
    end
  end

  defmodule CustomClient do
    use Tesla

    plug(EOSRPC.Middleware.Error)

    adapter fn (env) ->
      case env.url do
        "/200" ->
          {:ok, %{env | status: 200, body: "Everything fine"}}

        "/500" ->
          {:ok, %{env | status: 500, body: "Uoh!"}}
      end
    end
  end

  describe "Errors for HTTP verbs" do
    test "200 response reply normaly" do
      assert {:ok, env} = VanillaClient.get("/200")
      assert env.status == 200

      assert {:ok, env} = CustomClient.get("/200")
      assert env.status == 200
    end

    test "500 response reply as error" do
      assert {:ok, env} = VanillaClient.get("/500")
      assert env.status == 500

      assert {:error, env} = CustomClient.get("/500")
      assert env.status == 500
    end
  end

  describe "Error with bangs" do
    test "200 response reply normaly" do
      assert env = VanillaClient.get!("/200")
      assert env.status == 200

      assert env = CustomClient.get!("/200")
      assert env.status == 200
    end

    test "500 response reply throws exception" do
      assert_raise Tesla.Error, fn ->
        CustomClient.get!("/500")
      end
    end
  end
end
