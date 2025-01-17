defmodule YouTubeScrapperWeb.PlaylistLive.Index do
  use YouTubeScrapperWeb, :live_view

  alias YouTubeScrapper.Playlists
  alias YouTubeScrapper.Playlists.Playlist

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :playlists, Playlists.list_playlists())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Playlist")
    |> assign(:playlist, Playlists.get_playlist!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Playlist")
    |> assign(:playlist, %Playlist{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Playlists")
    |> assign(:playlist, nil)
  end

  @impl true
  def handle_info({YouTubeScrapperWeb.PlaylistLive.FormComponent, {:saved, playlist}}, socket) do
    {:noreply, stream_insert(socket, :playlists, playlist)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    playlist = Playlists.get_playlist!(id)
    {:ok, _} = Playlists.delete_playlist(playlist)

    {:noreply, stream_delete(socket, :playlists, playlist)}
  end
end
