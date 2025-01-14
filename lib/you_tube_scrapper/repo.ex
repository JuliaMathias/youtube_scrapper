defmodule YouTubeScrapper.Repo do
  use Ecto.Repo,
    otp_app: :you_tube_scrapper,
    adapter: Ecto.Adapters.Postgres
end
