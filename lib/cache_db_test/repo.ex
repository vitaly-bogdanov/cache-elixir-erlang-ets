defmodule CacheDbTest.Repo do
  use Ecto.Repo,
    otp_app: :cache_db_test,
    adapter: Ecto.Adapters.Postgres
end
