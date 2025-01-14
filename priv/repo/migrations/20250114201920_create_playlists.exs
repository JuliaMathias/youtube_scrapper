defmodule YouTubeScrapper.Repo.Migrations.CreatePlaylists do
  use Ecto.Migration

  def change do
    create table(:playlists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :link, :string
      add :last_scraping, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
