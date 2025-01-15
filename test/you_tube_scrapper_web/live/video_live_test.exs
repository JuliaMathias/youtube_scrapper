defmodule YouTubeScrapperWeb.VideoLiveTest do
  use YouTubeScrapperWeb.ConnCase

  import Phoenix.LiveViewTest
  import YouTubeScrapper.PlaylistsFixtures

  @create_attrs %{
    description: "some description",
    title: "some title",
    duration: "some duration",
    posted_on: "2025-01-13",
    url: "some url",
    playlist_id: nil
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    duration: "some updated duration",
    posted_on: "2025-01-14",
    url: "some updated url",
    playlist_id: nil
  }
  @invalid_attrs %{description: nil, title: nil, duration: nil, posted_on: nil, playlist_id: nil}

  defp create_video(_) do
    playlist = playlist_fixture()
    video = video_fixture(%{playlist_id: playlist.id})
    %{video: video, playlist: playlist}
  end

  describe "Index" do
    setup [:create_video]

    test "lists all videos", %{conn: conn, video: video} do
      {:ok, _index_live, html} = live(conn, ~p"/videos")

      assert html =~ "Listing Videos"
      assert html =~ video.description
    end

    test "saves new video", %{conn: conn, playlist: playlist} do
      {:ok, index_live, _html} = live(conn, ~p"/videos")

      assert index_live |> element("a", "New Video") |> render_click() =~
               "New Video"

      assert_patch(index_live, ~p"/videos/new")

      assert index_live
             |> form("#video-form", video: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#video-form", video: Map.put(@create_attrs, :playlist_id, playlist.id))
             |> render_submit()

      assert_patch(index_live, ~p"/videos")

      html = render(index_live)
      assert html =~ "Video created successfully"
      assert html =~ "some description"
    end

    test "updates video in listing", %{conn: conn, video: video, playlist: playlist} do
      {:ok, index_live, _html} = live(conn, ~p"/videos")

      assert index_live |> element("#videos-#{video.id} a", "Edit") |> render_click() =~
               "Edit Video"

      assert_patch(index_live, ~p"/videos/#{video}/edit")

      assert index_live
             |> form("#video-form", video: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#video-form", video: Map.put(@update_attrs, :playlist_id, playlist.id))
             |> render_submit()

      assert_patch(index_live, ~p"/videos")

      html = render(index_live)
      assert html =~ "Video updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes video in listing", %{conn: conn, video: video} do
      {:ok, index_live, _html} = live(conn, ~p"/videos")

      assert index_live |> element("#videos-#{video.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#videos-#{video.id}")
    end
  end

  describe "Show" do
    setup [:create_video]

    test "displays video", %{conn: conn, video: video} do
      {:ok, _show_live, html} = live(conn, ~p"/videos/#{video}")

      assert html =~ "Show Video"
      assert html =~ video.description
    end

    test "updates video within modal", %{conn: conn, video: video, playlist: playlist} do
      {:ok, show_live, _html} = live(conn, ~p"/videos/#{video}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Video"

      assert_patch(show_live, ~p"/videos/#{video}/show/edit")

      assert show_live
             |> form("#video-form", video: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#video-form", video: Map.put(@update_attrs, :playlist_id, playlist.id))
             |> render_submit()

      assert_patch(show_live, ~p"/videos/#{video}")

      html = render(show_live)
      assert html =~ "Video updated successfully"
      assert html =~ "some updated description"
    end
  end
end
