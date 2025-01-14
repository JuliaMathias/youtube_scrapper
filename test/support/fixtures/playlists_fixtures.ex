defmodule YouTubeScrapper.PlaylistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `YouTubeScrapper.Playlists` context.
  """

  @doc """
  Generate a playlist.
  """
  def playlist_fixture(attrs \\ %{}) do
    {:ok, playlist} =
      attrs
      |> Enum.into(%{
        last_scraping: ~N[2025-01-13 20:19:00],
        link: "some link",
        title: "some title"
      })
      |> YouTubeScrapper.Playlists.create_playlist()

    playlist
  end
end
