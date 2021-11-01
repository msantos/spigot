defmodule Spigot.Keepalive do
  @moduledoc "Send a keepalive message to the XMPP server"

  @spec start_link() :: {:ok, pid}
  def start_link() do
    seconds =
      Spigot.Config.get(:spigot, Spigot.Robot, :keepalive_interval, "60")
      |> String.to_integer()

    msg = Spigot.Utility.to_msg("ping")
    Task.start_link(fn -> run(%{msg | text: ""}, seconds) end)
  end

  defp run(msg, seconds) do
    :timer.sleep(:timer.seconds(seconds))
    Hedwig.Robot.send(Spigot.Utility.whereis(), msg)
    run(msg, seconds)
  end
end
