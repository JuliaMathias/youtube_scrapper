defmodule YouTubeScrapper.Playlists do
  @moduledoc """
  The Playlists context.
  """

  import Ecto.Query, warn: false
  alias YouTubeScrapper.Playlists.Playlist
  alias YouTubeScrapper.Playlists.Video
  alias YouTubeScrapper.Repo
  alias Crawly
  alias Floki

  @doc """
  Returns the list of playlists.

  ## Examples

      iex> list_playlists()
      [%Playlist{}, ...]

  """
  def list_playlists do
    Repo.all(Playlist)
  end

  @doc """
  Gets a single playlist.

  Raises `Ecto.NoResultsError` if the Playlist does not exist.

  ## Examples

      iex> get_playlist!(123)
      %Playlist{}

      iex> get_playlist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_playlist!(id), do: Repo.get!(Playlist, id)

  @doc """
  Creates a playlist.

  ## Examples

      iex> create_playlist(%{field: value})
      {:ok, %Playlist{}}

      iex> create_playlist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_playlist(attrs \\ %{}) do
    %Playlist{}
    |> Playlist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a playlist.

  ## Examples

      iex> update_playlist(playlist, %{field: new_value})
      {:ok, %Playlist{}}

      iex> update_playlist(playlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_playlist(%Playlist{} = playlist, attrs) do
    playlist
    |> Playlist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a playlist.

  ## Examples

      iex> delete_playlist(playlist)
      {:ok, %Playlist{}}

      iex> delete_playlist(playlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_playlist(%Playlist{} = playlist) do
    Repo.delete(playlist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking playlist changes.

  ## Examples

      iex> change_playlist(playlist)
      %Ecto.Changeset{data: %Playlist{}}

  """
  def change_playlist(%Playlist{} = playlist, attrs \\ %{}) do
    Playlist.changeset(playlist, attrs)
  end

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Repo.all(Video) |> Repo.preload(:playlist)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{data: %Video{}}

  """
  def change_video(%Video{} = video, attrs \\ %{}) do
    Video.changeset(video, attrs)
  end

  @doc """
  Scrapes a YouTube playlist and saves the playlist and video records.

  ## Examples

      iex> scrape_playlist("https://www.youtube.com/playlist?list=PL12345")
      :ok

  """
  def scrape_playlist(playlist_url) do
    {:ok, response} = Crawly.fetch(playlist_url)
    {:ok, document} = Floki.parse_document(response.body)

    playlist_title = Floki.find(document, "h1#title")[0] |> Floki.text()
    playlist = %Playlist{title: playlist_title, link: playlist_url}
    {:ok, playlist} = Repo.insert(playlist)

    video_elements = Floki.find(document, "ytd-playlist-video-renderer")
    Enum.each(video_elements, fn video_element ->
      video_title = Floki.find(video_element, "a#video-title")[0] |> Floki.text()
      video_duration = Floki.find(video_element, "span#text")[0] |> Floki.text()
      video_description = Floki.find(video_element, "yt-formatted-string#description-text")[0] |> Floki.text()
      video_posted_on = Floki.find(video_element, "div#metadata-line span")[1] |> Floki.text()
      video_url = Floki.find(video_element, "a#video-title")[0] |> Floki.attribute("href") |> List.first()

      video = %Video{
        title: video_title,
        duration: video_duration,
        description: video_description,
        posted_on: Date.from_iso8601!(video_posted_on),
        url: video_url,
        playlist_id: playlist.id
      }

      Repo.insert(video)
    end)

    playlist = Ecto.Changeset.change(playlist, last_scraping: NaiveDateTime.utc_now())
    Repo.update(playlist)

    :ok
  end
end
