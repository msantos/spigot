defmodule Spigot.Responders.Runlet do
  @moduledoc false

  use Hedwig.Responder

  hear ~r/^((info|help|ipaddr).*)/, msg do
    sh(msg, msg.matches[1])
  end

  respond ~r/(.*)/, msg do
    sh(msg, msg.matches[1])
  end

  @spec sh(Hedwig.Message.t(), String.t()) :: :ok
  def sh(msg, pipeline) do
    if Spigot.Config.debug(), do: :error_logger.info_report(runlet: msg)

    case Spigot.Utility.fork(msg, pipeline) do
      {:error, error} ->
        Hedwig.Responder.send(msg, error)

      {:ok, pid} ->
        Hedwig.Responder.reply(msg, "PID=#{Runlet.PID.to_string(pid)}")
    end
  end
end
