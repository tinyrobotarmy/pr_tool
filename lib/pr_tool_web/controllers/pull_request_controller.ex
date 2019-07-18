defmodule PrToolWeb.PullRequestController do
  use PrToolWeb, :controller

  alias PrTool.PullRequests
  alias PrTool.PullRequests.PullRequest

  action_fallback PrToolWeb.FallbackController

  def index(conn, %{"git_repo_id" => git_repo_id}) do
    pull_requests = PullRequests.list_pull_requests(git_repo_id)
    render(conn, "index.json", pull_requests: pull_requests)
  end

  def show(conn, %{"git_repo_id" => git_repo_id, "id" => id}) do
    pull_request = PullRequests.get_pull_request!(id)
    render(conn, "show.json", pull_request: pull_request)
  end
end
