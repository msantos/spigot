defmodule Spigot.Ctrl.Info do
  @moduledoc "Display bot status"

  @doc """
  bot configuration and status
  """
  @spec exec(Runlet.t()) :: Enumerable.t()
  def exec(%Runlet{} = env) do
    [
      to_event(config(env)),
      Runlet.Cmd.Runtime.exec()
    ]
    |> List.flatten()
  end

  defp to_event(e) do
    %Runlet.Event{
      event: %Runlet.Event.Ctrl{
        service: "info",
        description: "_bot configuration_\n\n#{e}"
      },
      query: "info"
    }
  end

  defp config(%Runlet{}) do
    """
    *name*: #{Spigot.Config.name()}
    *alias*: #{Spigot.Config.aka()}
    *jid*: #{Spigot.Config.jid()}
    *rooms*:
    #{Spigot.Config.rooms() |> Enum.map(fn {room, _} -> "* " <> room end) |> Enum.join("\n")}
    """
  end
end
