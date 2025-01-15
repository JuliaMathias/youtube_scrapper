defmodule YouTubeScrapper.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :duration, :string
      add :description, :text
      add :scraped_on, :date
      add :playlist_id, references(:playlists, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:videos, [:playlist_id])
  end
end
