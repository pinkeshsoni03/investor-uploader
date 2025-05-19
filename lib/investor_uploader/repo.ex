defmodule InvestorUploader.Repo do
  use Ecto.Repo,
    otp_app: :investor_uploader,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 5
end
