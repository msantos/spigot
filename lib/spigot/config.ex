defmodule Spigot.Config do
  @moduledoc "Retrieve bot configuration from application environment"

  def name(), do: get(:spigot, Spigot.Robot, :name)

  def password(),
    do: get(:spigot, Spigot.Robot, :password)

  def jid(), do: get(:spigot, Spigot.Robot, :jid)
  def aka(), do: get(:spigot, Spigot.Robot, :aka)
  def rooms(), do: get(:spigot, Spigot.Robot, :rooms)

  def get(app, key, subkey, default \\ nil) do
    case Application.get_env(app, key) do
      nil -> default
      opt -> Keyword.get(opt, subkey, default)
    end
  end
end
