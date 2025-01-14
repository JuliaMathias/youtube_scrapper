defmodule YouTubeScrapperWeb.Router do
  use YouTubeScrapperWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {YouTubeScrapperWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", YouTubeScrapperWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/playlists", PlaylistLive.Index, :index
    live "/playlists/new", PlaylistLive.Index, :new
    live "/playlists/:id/edit", PlaylistLive.Index, :edit

    live "/playlists/:id", PlaylistLive.Show, :show
    live "/playlists/:id/show/edit", PlaylistLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", YouTubeScrapperWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:you_tube_scrapper, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: YouTubeScrapperWeb.Telemetry
    end
  end
end
