defmodule Extagram.Repo do
  use Ecto.Repo,
    otp_app: :extagram,
    adapter: Ecto.Adapters.Postgres
end
