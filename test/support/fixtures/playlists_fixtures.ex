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

  @doc """
  Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        description: "some description",
        duration: "12:45",
        posted_on: ~D[2025-01-13],
        title: "some title",
        url: "some url"
      })
      |> YouTubeScrapper.Playlists.create_video()

    video
  end
end
