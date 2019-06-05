defmodule PrToolWeb.GitRepoView do
  use PrToolWeb, :view
  alias PrToolWeb.GitRepoView

  def render("index.json", %{git_repos: git_repos}) do
    %{data: render_many(git_repos, GitRepoView, "git_repo.json", merged_series: [], changed_files_series: [], changes_series: [])}
  end

  def render("show.json", %{git_repo: git_repo, merged_series: merged_series, changed_files_series: changed_files_series, changes_series: changes_series}) do
    %{data: render_one(git_repo, GitRepoView, "git_repo.json", %{merged_series: merged_series, changed_files_series: changed_files_series, changes_series: changes_series})}
  end

  def render("git_repo.json", %{git_repo: git_repo, merged_series: merged_series, changed_files_series: changed_files_series, changes_series: changes_series}) do
    %{id: git_repo.id,
      name: git_repo.name,
      url: git_repo.url,
      merged_series: merged_series,
      changed_files_series: changed_files_series,
      changes_series: changes_series
    }
  end
end
