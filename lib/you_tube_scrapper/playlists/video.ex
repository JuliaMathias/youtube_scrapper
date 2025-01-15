defmodule YouTubeScrapper.Playlists.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "videos" do
    field :description, :string
    field :title, :string
    field :duration, :string
    field :posted_on, :date
    field :url, :string

    belongs_to :playlist, YouTubeScrapper.Playlists.Playlist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :duration, :description, :posted_on, :url, :playlist_id])
    |> validate_required([:title, :duration, :description, :posted_on, :url, :playlist_id])
  end
end
