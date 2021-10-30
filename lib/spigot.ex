defmodule Spigot do
  @moduledoc "Supervises the XMPP interface and runlet processes"

  use Application

  def start(_type, _args) do
    children = [
      %{
        id: Spigot.Robot,
        start: {Spigot.Robot, :start_link, []},
        type: :worker
      },
      %{
        id: Runlet,
        start: {Runlet, :start_link, []}
      },
      %{
        id: Runlet.Process,
        start:
          {Runlet.Process, :start_link,
           [
             fn %Runlet{uid: uid} ->
               msg = Spigot.Utility.to_msg(uid)

               fn stdout ->
                 Hedwig.Robot.send(Spigot.Utility.whereis(), %{
                   msg
                   | text: Spigot.Utility.to_stdout(stdout)
                 })
               end
             end
           ]}
      },
      %{
        id: Spigot.Keepalive,
        start: {Spigot.Keepalive, :start_link, []}
      }
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_all,
      name: Spigot.Supervisor
    )
  end
end
