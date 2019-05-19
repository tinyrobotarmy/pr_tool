defmodule PrToolWeb.PullRequestController do
  use PrToolWeb, :controller

  alias PrTool.PullRequests
  alias PrTool.PullRequests.PullRequest

  action_fallback PrToolWeb.FallbackController

  def index(conn, _params) do
    pull_requests = PullRequests.list_pull_requests()
    render(conn, "index.json", pull_requests: pull_requests)
  end

  def create(conn, %{"pull_request" => pull_request_params}) do
    with {:ok, %PullRequest{} = pull_request} <- PullRequests.create_pull_request(pull_request_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.pull_request_path(conn, :show, pull_request))
      |> render("show.json", pull_request: pull_request)
    end
  end

  def show(conn, %{"id" => id}) do
    pull_request = PullRequests.get_pull_request!(id)
    render(conn, "show.json", pull_request: pull_request)
  end

  def update(conn, %{"id" => id, "pull_request" => pull_request_params}) do
    pull_request = PullRequests.get_pull_request!(id)

    with {:ok, %PullRequest{} = pull_request} <- PullRequests.update_pull_request(pull_request, pull_request_params) do
      render(conn, "show.json", pull_request: pull_request)
    end
  end

  def delete(conn, %{"id" => id}) do
    pull_request = PullRequests.get_pull_request!(id)

    with {:ok, %PullRequest{}} <- PullRequests.delete_pull_request(pull_request) do
      send_resp(conn, :no_content, "")
    end
  end
end
