defmodule PrToolWeb.GitRepoController do
  use PrToolWeb, :controller

  alias PrTool.GitRepos
  alias PrTool.GitRepos.GitRepo
  alias PrTool.PullRequests

  action_fallback PrToolWeb.FallbackController

  def index(conn, _params) do
    git_repos = GitRepos.list_git_repos()
    render(conn, "index.json", git_repos: git_repos)
  end

  def create(conn, %{"git_repo" => git_repo_params}) do
    with {:ok, %GitRepo{} = git_repo} <- GitRepos.create_git_repo(git_repo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.git_repo_path(conn, :show, git_repo))
      |> render("show.json", git_repo: git_repo, series: [])
    end
  end

  def show(conn, %{"id" => id}) do
    git_repo = GitRepos.get_git_repo!(id)
    series = git_repo.id
      |> PullRequests.as_time_series()
      |> PullRequests.process_for_average()
    render(conn, "show.json", git_repo: git_repo, series: series)
  end

  def update(conn, %{"id" => id, "git_repo" => git_repo_params}) do
    git_repo = GitRepos.get_git_repo!(id)

    with {:ok, %GitRepo{} = git_repo} <- GitRepos.update_git_repo(git_repo, git_repo_params) do
      render(conn, "show.json", git_repo: git_repo)
    end
  end

  def delete(conn, %{"id" => id}) do
    git_repo = GitRepos.get_git_repo!(id)

    with {:ok, %GitRepo{}} <- GitRepos.delete_git_repo(git_repo) do
      send_resp(conn, :no_content, "")
    end
  end
end
