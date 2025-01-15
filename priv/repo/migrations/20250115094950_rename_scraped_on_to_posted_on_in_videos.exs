defmodule YouTubeScrapper.Repo.Migrations.RenameScrapedOnToPostedOnInVideos do
  use Ecto.Migration

  def change do
    rename table(:videos), :scraped_on, to: :posted_on
  end
end
