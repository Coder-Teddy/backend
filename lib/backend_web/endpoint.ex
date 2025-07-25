defmodule BackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :backend

  plug CORSPlug,
  origin: [
    "http://localhost:3000",
    "http://localhost:5173",
    "https://backend-cold-snowflake-4736.fly.dev",
    "https://invideoai-assignment-kunal-coderteddys-projects.vercel.app",
    "https://invideoai-assignment-kunal-git-main-coderteddys-projects.vercel.app",
    "https://invideoai-assignment-kunal.vercel.app"
    ],
  max_age: 86400,
  methods: ["GET", "POST", "OPTIONS"],
  headers: ["content-type"]

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_backend_key",
    signing_salt: "0+QTB7VU",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :backend,
    gzip: false,
    only: BackendWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BackendWeb.Router
end
