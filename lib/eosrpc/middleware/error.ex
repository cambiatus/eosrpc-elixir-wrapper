defmodule EOSRPC.Middleware.Error do
  @behaviour Tesla.Middleware

  @moduledoc """
  Makes requests that don't respond to HTTP Success codes to return as a error


  ### Example usage
  ```
  defmodule MyClient do
    use Tesla

    plug(EOSRPC.ErrorMiddleware)
  end
  ```
  """

  def call(env, next, _options) do
    env
    |> Tesla.run(next)
    |> case do
         {:ok, env} ->
           case env.status do
             s when s in [200, 201, 202, 203, 204] -> {:ok, env}
             _ -> {:error, env}
           end

         env ->
           env
       end
  end
end
