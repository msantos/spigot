import Config

config :spigot, Spigot.Robot,
  adapter: Hedwig.Adapters.XMPP,
  name: {:system, "EVENTBOT_USERNAME"},
  password: {:system, "EVENTBOT_PASSWORD"},
  jid: {:system, "EVENTBOT_JID"},
  aka: {:system, "EVENTBOT_ALIAS"},
  rooms: {:system, "EVENTBOT_ROOMS"},
  responders: [
    {Spigot.Responders.Runlet, []}
  ]
