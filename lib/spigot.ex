defmodule Spigot do
  @moduledoc "Supervises the XMPP interface and runlet processes"

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Spigot.Worker.start_link(arg1, arg2, arg3)
      # worker(Spigot.Worker, [arg1, arg2, arg3]),
      worker(Spigot.Robot, []),
      supervisor(Runlet, []),
      supervisor(Runlet.Process, [
        fn %Runlet{uid: uid} ->
          msg = Spigot.Utility.to_msg(uid)

          fn stdout ->
            Hedwig.Robot.send(Spigot.Utility.whereis(), %{
              msg
              | text: Spigot.Utility.to_stdout(stdout)
            })
          end
        end
      ]),
      worker(Spigot.Keepalive, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Spigot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
