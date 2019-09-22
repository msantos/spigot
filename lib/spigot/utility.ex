defmodule Spigot.Utility do
  @moduledoc false

  @spec fork(Hedwig.Message.t(), String.t()) ::
          {:ok, pid} | {:error, String.t()}
  def fork(msg, pipeline) do
    name = Spigot.Utility.name(msg)

    Runlet.fork(%Runlet{
      state: msg,
      uid: name,
      pipeline: pipeline,
      stdout: fn _env ->
        fn stdout ->
          Hedwig.Robot.send(whereis(), %{msg | text: to_stdout(stdout)})
        end
      end
    })
  end

  @spec botname() :: String.t() | :undefined
  def botname() do
    case Spigot.Config.name() do
      nil -> :undefined
      n -> n
    end
  end

  @spec whereis() :: pid() | :undefined
  def whereis() do
    :global.whereis_name(botname())
  end

  @spec name(Hedwig.Message.t()) :: String.t()
  def name(%Hedwig.Message{user: %Hedwig.User{id: id}, room: nil}) do
    String.replace(Romeo.JID.bare(id), ~r([^a-zA-Z0-9_@.-]), "_")
  end

  def name(%Hedwig.Message{room: room}) do
    String.replace(room, ~r([^a-zA-Z0-9_@.-]), "_")
  end

  @spec to_msg(Hedwig.Message.t() | binary) :: Hedwig.Message.t()
  def to_msg(%Hedwig.Message{} = msg), do: msg

  def to_msg(id) when is_binary(id) do
    case String.split(id, "@") do
      [_, <<"conference.", _::binary>>] ->
        %Hedwig.Message{
          type: "groupchat",
          room: id
        }

      [_, <<"muc.", _::binary>>] ->
        %Hedwig.Message{
          type: "groupchat",
          room: id
        }

      _ ->
        %Hedwig.Message{
          type: "chat",
          user: %Hedwig.User{
            id: id
          }
        }
    end
  end

  @spec to_stdout(any) :: binary
  def to_stdout(stdout) when is_binary(stdout), do: stdout
  def to_stdout(stdout), do: "#{inspect(stdout)}"
end
