defmodule Spigot.Robot do
  @moduledoc "XMPP interface to runlets"

  use Hedwig.Robot,
    otp_app: :spigot,
    name: Spigot.Config.name(),
    password: Spigot.Config.password(),
    jid: Spigot.Config.jid(),
    aka: Spigot.Config.aka(),
    rooms: Spigot.Config.rooms()

  def handle_connect(%{name: name} = state) do
    if :undefined == :global.whereis_name(name) do
      :yes = :global.register_name(name, self())
    end

    {:ok, state}
  end
end
