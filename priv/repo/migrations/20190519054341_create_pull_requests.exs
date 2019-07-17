defmodule PrTool.Repo.Migrations.CreatePullRequests do
  use Ecto.Migration

  def change do
    create table(:pull_requests) do
      add :external_id, :integer
      add :title, :string
      add :author, :string
      add :reviewers, :integer
      add :commits, :integer
      add :comments, :integer
      add :changed_files, :integer
      add :additions, :integer
      add :deletions, :integer
      add :days_to_merge, :integer
      add :created_at, :utc_datetime
      add :closed_at, :utc_datetime
      add :merged_at, :utc_datetime

      add :git_repo_id, references(:git_repos, on_delete: :delete_all)

      timestamps()
    end

  end
end
