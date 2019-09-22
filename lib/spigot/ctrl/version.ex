defmodule Spigot.Ctrl.Version do
  @moduledoc "Display application versions"

  @doc """
  All the application versions
  """
  @spec exec(Runlet.t()) :: Enumerable.t()
  def exec(%Runlet{} = env) do
    env
    |> apps()
    |> to_event()
  end

  defp to_event(e) do
    [
      %Runlet.Event{
        event: %Runlet.Event.Ctrl{
          service: "version",
          description: e
        },
        query: "version"
      }
    ]
  end

  defp apps(%Runlet{}) do
    Application.loaded_applications()
    |> List.keysort(0)
    |> Enum.map(fn {name, descr, version} -> "#{name}/#{version} - #{descr}" end)
    |> Enum.join("\n")
  end
end
