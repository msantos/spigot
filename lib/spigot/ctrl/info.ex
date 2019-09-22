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
        description: "Configuration\n=============\n#{e}"
      },
      query: "info"
    }
  end

  defp config(%Runlet{}) do
    [
      name: Spigot.Config.name(),
      aka: Spigot.Config.aka(),
      jid: Spigot.Config.jid(),
      rooms: Spigot.Config.rooms()
    ]
    |> Enum.map(fn
      {k, v} when is_list(v) ->
        ["#{k}=", Enum.map(v, fn {n, _} -> "#{n}" end)]
        |> List.flatten()
        |> Enum.join("\n")

      {k, v} ->
        "#{k}=#{v}"
    end)
    |> Enum.join("\n")
  end
end
