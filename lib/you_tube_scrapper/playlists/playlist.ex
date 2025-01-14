defmodule YouTubeScrapper.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "playlists" do
    field :link, :string
    field :title, :string
    field :last_scraping, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:title, :link, :last_scraping])
    |> validate_required([:title, :link, :last_scraping])
  end
end
