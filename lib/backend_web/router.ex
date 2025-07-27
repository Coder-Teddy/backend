defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api
    post "/shader", ShaderController, :generate
    get "/shaders", ShaderController, :index
    get "/shaders/:id", ShaderController, :show
  end
end
