defmodule Libraryr.Repo do
  use Ecto.Repo,
    otp_app: :libraryr,
    adapter: Ecto.Adapters.Postgres
end
