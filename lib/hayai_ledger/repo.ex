defmodule HayaiLedger.Repo do
  use Ecto.Repo,
    otp_app: :hayai_ledger,
    adapter: Ecto.Adapters.Postgres
end
