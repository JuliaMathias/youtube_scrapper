defmodule YouTubeScrapper.PlaylistsTest do
  use YouTubeScrapper.DataCase

  import YouTubeScrapper.PlaylistsFixtures

  alias YouTubeScrapper.Playlists
  alias YouTubeScrapper.Playlists.Playlist
  alias YouTubeScrapper.Playlists.Video

  describe "playlists" do
    @invalid_attrs %{link: nil, title: nil, last_scraping: nil}

    test "list_playlists/0 returns all playlists" do
      playlist = playlist_fixture()
      assert Playlists.list_playlists() == [playlist]
    end

    test "get_playlist!/1 returns the playlist with given id" do
      playlist = playlist_fixture()
      assert Playlists.get_playlist!(playlist.id) == playlist
    end

    test "create_playlist/1 with valid data creates a playlist" do
      valid_attrs = %{
        link: "some link",
        title: "some title",
        last_scraping: ~N[2025-01-13 20:19:00]
      }

      assert {:ok, %Playlist{} = playlist} = Playlists.create_playlist(valid_attrs)
      assert playlist.link == "some link"
      assert playlist.title == "some title"
      assert playlist.last_scraping == ~N[2025-01-13 20:19:00]
    end

    test "create_playlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Playlists.create_playlist(@invalid_attrs)
    end

    test "update_playlist/2 with valid data updates the playlist" do
      playlist = playlist_fixture()

      update_attrs = %{
        link: "some updated link",
        title: "some updated title",
        last_scraping: ~N[2025-01-14 20:19:00]
      }

      assert {:ok, %Playlist{} = playlist} = Playlists.update_playlist(playlist, update_attrs)
      assert playlist.link == "some updated link"
      assert playlist.title == "some updated title"
      assert playlist.last_scraping == ~N[2025-01-14 20:19:00]
    end

    test "update_playlist/2 with invalid data returns error changeset" do
      playlist = playlist_fixture()
      assert {:error, %Ecto.Changeset{}} = Playlists.update_playlist(playlist, @invalid_attrs)
      assert playlist == Playlists.get_playlist!(playlist.id)
    end

    test "delete_playlist/1 deletes the playlist" do
      playlist = playlist_fixture()
      assert {:ok, %Playlist{}} = Playlists.delete_playlist(playlist)
      assert_raise Ecto.NoResultsError, fn -> Playlists.get_playlist!(playlist.id) end
    end

    test "change_playlist/1 returns a playlist changeset" do
      playlist = playlist_fixture()
      assert %Ecto.Changeset{} = Playlists.change_playlist(playlist)
    end
  end

  describe "videos" do
    test "list_videos/0 returns all videos" do
      playlist = playlist_fixture()
      video = video_fixture(%{playlist_id: playlist.id})
      video = Playlists.get_video!(video.id) |> Repo.preload(:playlist)
      assert Playlists.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      playlist = playlist_fixture()
      video = video_fixture(%{playlist_id: playlist.id})
      assert Playlists.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      playlist = playlist_fixture()

      valid_attrs = %{
        description: "some description",
        title: "some title",
        duration: "34:23",
        posted_on: ~D[2025-01-13],
        url: "some url",
        playlist_id: playlist.id
      }

      assert {:ok, %Video{} = video} = Playlists.create_video(valid_attrs)
      assert video.description == "some description"
      assert video.title == "some title"
      assert video.duration == "34:23"
      assert video.posted_on == ~D[2025-01-13]
      assert video.url == "some url"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Playlists.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      playlist = playlist_fixture()
      video = video_fixture(%{playlist_id: playlist.id})

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        duration: "some updated duration",
        posted_on: ~D[2025-01-14],
        url: "some updated url"
      }

      assert {:ok, %Video{} = video} = Playlists.update_video(video, update_attrs)
      assert video.description == "some updated description"
      assert video.title == "some updated title"
      assert video.duration == "some updated duration"
      assert video.posted_on == ~D[2025-01-14]
      assert video.url == "some updated url"
    end

    test "update_video/2 with invalid data returns error changeset" do
      playlist = playlist_fixture()
      video = video_fixture(%{playlist_id: playlist.id})
      assert {:error, %Ecto.Changeset{}} = Playlists.update_video(video, @invalid_attrs)
      assert video == Playlists.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      playlist = playlist_fixture()
      video = video_fixture(%{playlist_id: playlist.id})
      assert {:ok, %Video{}} = Playlists.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Playlists.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      playlist = playlist_fixture()
      video = video_fixture(%{playlist_id: playlist.id})
      assert %Ecto.Changeset{} = Playlists.change_video(video)
    end
  end
end
