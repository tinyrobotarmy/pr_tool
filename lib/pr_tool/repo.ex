defmodule PrTool.Repo do
  use Ecto.Repo,
    otp_app: :pr_tool,
    adapter: Ecto.Adapters.Postgres
end
