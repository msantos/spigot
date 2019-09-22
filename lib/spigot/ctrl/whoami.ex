defmodule Spigot.Ctrl.Whoami do
  @moduledoc "Display username"

  @doc """
  Display the username for history and process management.
  """
  @spec exec(Runlet.t()) :: Enumerable.t()
  def exec(%Runlet{state: msg}) do
    [
      %Runlet.Event{
        event: %Runlet.Event.Ctrl{
          service: "whoami",
          description: Spigot.Utility.name(msg)
        },
        query: "whoami"
      }
    ]
  end
end
