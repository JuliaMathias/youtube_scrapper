defmodule YouTubeScrapperWeb.ScrapeLive do
  use YouTubeScrapperWeb, :live_view

  alias YouTubeScrapper.Playlists

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :videos, [])}
  end

  @impl true
  def handle_event("scrape", %{"playlist_url" => playlist_url}, socket) do
    Playlists.scrape_playlist(playlist_url)
    videos = Playlists.list_videos() |> Enum.sort_by(& &1.posted_on)
    {:noreply, assign(socket, :videos, videos)}
  end
end
