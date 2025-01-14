defmodule YouTubeScrapperWeb.PlaylistLiveTest do
  use YouTubeScrapperWeb.ConnCase

  import Phoenix.LiveViewTest
  import YouTubeScrapper.PlaylistsFixtures

  @create_attrs %{link: "some link", title: "some title", last_scraping: "2025-01-13T20:19:00"}
  @update_attrs %{link: "some updated link", title: "some updated title", last_scraping: "2025-01-14T20:19:00"}
  @invalid_attrs %{link: nil, title: nil, last_scraping: nil}

  defp create_playlist(_) do
    playlist = playlist_fixture()
    %{playlist: playlist}
  end

  describe "Index" do
    setup [:create_playlist]

    test "lists all playlists", %{conn: conn, playlist: playlist} do
      {:ok, _index_live, html} = live(conn, ~p"/playlists")

      assert html =~ "Listing Playlists"
      assert html =~ playlist.link
    end

    test "saves new playlist", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/playlists")

      assert index_live |> element("a", "New Playlist") |> render_click() =~
               "New Playlist"

      assert_patch(index_live, ~p"/playlists/new")

      assert index_live
             |> form("#playlist-form", playlist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#playlist-form", playlist: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/playlists")

      html = render(index_live)
      assert html =~ "Playlist created successfully"
      assert html =~ "some link"
    end

    test "updates playlist in listing", %{conn: conn, playlist: playlist} do
      {:ok, index_live, _html} = live(conn, ~p"/playlists")

      assert index_live |> element("#playlists-#{playlist.id} a", "Edit") |> render_click() =~
               "Edit Playlist"

      assert_patch(index_live, ~p"/playlists/#{playlist}/edit")

      assert index_live
             |> form("#playlist-form", playlist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#playlist-form", playlist: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/playlists")

      html = render(index_live)
      assert html =~ "Playlist updated successfully"
      assert html =~ "some updated link"
    end

    test "deletes playlist in listing", %{conn: conn, playlist: playlist} do
      {:ok, index_live, _html} = live(conn, ~p"/playlists")

      assert index_live |> element("#playlists-#{playlist.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#playlists-#{playlist.id}")
    end
  end

  describe "Show" do
    setup [:create_playlist]

    test "displays playlist", %{conn: conn, playlist: playlist} do
      {:ok, _show_live, html} = live(conn, ~p"/playlists/#{playlist}")

      assert html =~ "Show Playlist"
      assert html =~ playlist.link
    end

    test "updates playlist within modal", %{conn: conn, playlist: playlist} do
      {:ok, show_live, _html} = live(conn, ~p"/playlists/#{playlist}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Playlist"

      assert_patch(show_live, ~p"/playlists/#{playlist}/show/edit")

      assert show_live
             |> form("#playlist-form", playlist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#playlist-form", playlist: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/playlists/#{playlist}")

      html = render(show_live)
      assert html =~ "Playlist updated successfully"
      assert html =~ "some updated link"
    end
  end
end
