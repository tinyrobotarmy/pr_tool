defmodule PrTool.Repo.Migrations.CreatePullRequests do
  use Ecto.Migration

  def change do
    create table(:pull_requests) do
      add :title, :string
      add :author, :string
      add :reviewers, :integer
      add :commits, :integer
      add :comments, :integer
      add :changed_files, :integer
      add :additions, :integer
      add :deletions, :integer
      add :days_to_merge, :integer

      timestamps()
    end

  end
end
