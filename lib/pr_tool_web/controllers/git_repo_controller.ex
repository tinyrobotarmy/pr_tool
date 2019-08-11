defmodule PrToolWeb.GitRepoController do
  use PrToolWeb, :controller

  alias PrTool.GitRepos.GitRepo
  alias PrTool.PullRequests.PullRequestManager
  alias PrTool.{GitRepos, PullRequests}

  action_fallback PrToolWeb.FallbackController

  def index(conn, _params) do
    git_repos = GitRepos.list_git_repos()
    render(conn, "index.json", git_repos: git_repos)
  end

  def create(conn, %{"git_repo" => %{"username" => username, "password" => password, "name" => name, "url" => url}}) do
    with {:ok, %GitRepo{} = git_repo} <- GitRepos.create_git_repo(%{"name" => name, "url" => url}) do
      Task.async(fn -> PullRequestManager.load_pulls(git_repo, username, password) end)
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.git_repo_path(conn, :show, git_repo))
      |> render("summary.json", git_repo: git_repo)
    end
  end

  def reload(conn, %{"id" => id, "git_repo" => %{"username" => username, "password" => password}}) do
    git_repo = GitRepos.get_git_repo!(id)
    Task.async(fn -> PullRequestManager.load_pulls(git_repo, username, password) end)
    conn
    |> put_status(:created)
    |> put_resp_header("location", Routes.git_repo_path(conn, :show, git_repo))
    |> render("summary.json", git_repo: git_repo)
  end

  def show(conn, %{"id" => id}) do
    git_repo = GitRepos.get_git_repo!(id)
    series = PullRequests.as_time_series(git_repo.id)
    merged_series = PullRequests.process_for_average(series, :days_to_merge)
    changed_files_series = PullRequests.process_for_average(series, :changed_files)
    changes_series = PullRequests.process_field_pair_for_average(series, :additions, :deletions)
    comments_series = PullRequests.process_for_average(series, :comments)
    reviewers_series = PullRequests.process_for_average(series, :reviewers)
    render(conn, "show.json", git_repo: git_repo, merged_series: merged_series, changed_files_series: changed_files_series,
           changes_series: changes_series, comments_series: comments_series, reviewers_series: reviewers_series)
  end

  def update(conn, %{"id" => id, "git_repo" => git_repo_params}) do
    git_repo = GitRepos.get_git_repo!(id)

    with {:ok, %GitRepo{} = git_repo} <- GitRepos.update_git_repo(git_repo, git_repo_params) do
      render(conn, "summary.json", git_repo: git_repo)
    end
  end

  def delete(conn, %{"id" => id}) do
    git_repo = GitRepos.get_git_repo!(id)

    with {:ok, %GitRepo{}} <- GitRepos.delete_git_repo(git_repo) do
      send_resp(conn, :no_content, "")
    end
  end
end
