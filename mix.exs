defmodule EOSRPC.Mixfile do
  use Mix.Project

  def project do
    [
      app: :eosrpc,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "1.0.0-beta.1"},
      {:jason, ">= 1.0.0"},
      {:timex, "~> 3.1"}
    ]
  end
end
