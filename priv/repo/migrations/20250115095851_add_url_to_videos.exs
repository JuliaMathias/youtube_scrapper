defmodule YouTubeScrapper.Repo.Migrations.AddUrlToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :url, :string
    end
  end
end
