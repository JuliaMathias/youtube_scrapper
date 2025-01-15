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
    field :playlist_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :duration, :description, :posted_on])
    |> validate_required([:title, :duration, :description, :posted_on])
  end
end
