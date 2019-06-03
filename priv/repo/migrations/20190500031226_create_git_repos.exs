defmodule PrTool.Repo.Migrations.CreateGitRepos do
  use Ecto.Migration

  def change do
    create table(:git_repos) do
      add :name, :string
      add :url, :string

      timestamps()
    end

  end
end
