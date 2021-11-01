defmodule Spigot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :spigot,
      version: "1.1.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "XMPP transport for runlets",
      deps: deps(),
      dialyzer: [
        list_unused_filters: true,
        flags: [
          "-Wunmatched_returns",
          :error_handling,
          :race_conditions,
          :underspecs
        ]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :hedwig_xmpp, :ex_rated, :runlet],
      mod: {Spigot, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:romeo, git: "https://github.com/scrogson/romeo.git", override: true},
      {:fast_xml, "~> 1.1.29", override: true, manager: :rebar3},
      {:hedwig_xmpp, "~> 1.0.0"},
      {:runlet, git: "https://github.com/msantos/runlet.git"},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false}
    ]
  end
end
