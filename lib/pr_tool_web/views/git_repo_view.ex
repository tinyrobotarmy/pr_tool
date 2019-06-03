defmodule PrToolWeb.GitRepoView do
  use PrToolWeb, :view
  alias PrToolWeb.GitRepoView

  def render("index.json", %{git_repos: git_repos}) do
    %{data: render_many(git_repos, GitRepoView, "git_repo.json", series: [])}
  end

  def render("show.json", %{git_repo: git_repo, series: series}) do
    %{data: render_one(git_repo, GitRepoView, "git_repo.json", %{series: series})}
  end

  def render("git_repo.json", %{git_repo: git_repo, series: series}) do
    %{id: git_repo.id,
      name: git_repo.name,
      url: git_repo.url,
      monthly_series: series
    }
  end
end
