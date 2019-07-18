defmodule PrToolWeb.PullRequestControllerTest do
  use PrToolWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_git_repo]
    test "lists all pull_requests", %{conn: conn, git_repo: git_repo} do
      conn = get(conn, Routes.git_repo_pull_request_path(conn, :index, git_repo.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show pull_request" do
    setup [:create_pull_request]
    test "renders pull_request when data is valid", %{conn: conn, git_repo: git_repo, pull_request: pull_request} do

      conn = get(conn, Routes.git_repo_pull_request_path(conn, :show, git_repo.id, pull_request.id))

      assert %{
        "id" => pull_request.id,
        "additions" => pull_request.additions,
        "author" => pull_request.author,
        "changed_files" => pull_request.changed_files,
        "comments" => pull_request.comments,
        "commits" => pull_request.commits,
        "days_to_merge" => pull_request.days_to_merge,
        "deletions" => pull_request.deletions,
        "reviewers" => pull_request.reviewers,
        "title" => pull_request.title
      } == json_response(conn, 200)["data"]
    end
  end

  defp create_git_repo(_) do
    git_repo = Factory.create_git_repo()
    {:ok, git_repo: git_repo}
  end

  defp create_pull_request(_) do
    git_repo = Factory.create_git_repo()
    pull_request = Factory.create_pull_request(%{"git_repo_id" => git_repo.id})
    {:ok, pull_request: pull_request, git_repo: git_repo}
  end
end
