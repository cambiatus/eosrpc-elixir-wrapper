defmodule EOSRPC.Error do
  require Logger

  defexception [:reason, :url]

  def exception(reason, url \\ "")
  def exception(reason, url), do: %__MODULE__{reason: reason, url: url}

  def message(%__MODULE__{reason: reason, url: url}) do
    Logger.error("EOSRPC call failed: #{reason}", url: url)
  end
end
