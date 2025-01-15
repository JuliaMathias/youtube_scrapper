defmodule YouTubeScrapperWeb.ScrapeLiveTest do
  use YouTubeScrapperWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias YouTubeScrapper.Playlists

  @valid_playlist_url "https://www.youtube.com/playlist?list=PL12345"

  describe "ScrapeLive" do
    test "renders the scrape form and scrapes videos", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/scrape")

      assert has_element?(view, "h1", "Which video would you like to scrape?")
      assert has_element?(view, "form[phx-submit=scrape]")

      {:ok, _playlist} = Playlists.scrape_playlist(@valid_playlist_url)

      send(view, :scrape, %{"playlist_url" => @valid_playlist_url})

      assert has_element?(view, "table#videos")
      assert has_element?(view, "td", "Video Title 1")
      assert has_element?(view, "td", "Video Title 2")
    end
  end
end
