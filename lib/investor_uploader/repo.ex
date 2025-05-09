defmodule InvestorUploader.Repo do
  use Ecto.Repo,
    otp_app: :investor_uploader,
    adapter: Ecto.Adapters.Postgres
end
