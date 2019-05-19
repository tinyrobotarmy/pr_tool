defmodule PrToolWeb.PullRequestControllerTest do
  use PrToolWeb.ConnCase

  alias PrTool.PullRequests
  alias PrTool.PullRequests.PullRequest

  @create_attrs %{
    additions: 42,
    author: "some author",
    changed_files: 42,
    comments: 42,
    commits: 42,
    days_to_merge: 42,
    deletions: 42,
    reviewers: 42,
    title: "some title"
  }
  @update_attrs %{
    additions: 43,
    author: "some updated author",
    changed_files: 43,
    comments: 43,
    commits: 43,
    days_to_merge: 43,
    deletions: 43,
    reviewers: 43,
    title: "some updated title"
  }
  @invalid_attrs %{additions: nil, author: nil, changed_files: nil, comments: nil, commits: nil, days_to_merge: nil, deletions: nil, reviewers: nil, title: nil}

  def fixture(:pull_request) do
    {:ok, pull_request} = PullRequests.create_pull_request(@create_attrs)
    pull_request
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all pull_requests", %{conn: conn} do
      conn = get(conn, Routes.pull_request_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create pull_request" do
    test "renders pull_request when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pull_request_path(conn, :create), pull_request: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.pull_request_path(conn, :show, id))

      assert %{
               "id" => id,
               "additions" => 42,
               "author" => "some author",
               "changed_files" => 42,
               "comments" => 42,
               "commits" => 42,
               "days_to_merge" => 42,
               "deletions" => 42,
               "reviewers" => 42,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pull_request_path(conn, :create), pull_request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update pull_request" do
    setup [:create_pull_request]

    test "renders pull_request when data is valid", %{conn: conn, pull_request: %PullRequest{id: id} = pull_request} do
      conn = put(conn, Routes.pull_request_path(conn, :update, pull_request), pull_request: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.pull_request_path(conn, :show, id))

      assert %{
               "id" => id,
               "additions" => 43,
               "author" => "some updated author",
               "changed_files" => 43,
               "comments" => 43,
               "commits" => 43,
               "days_to_merge" => 43,
               "deletions" => 43,
               "reviewers" => 43,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, pull_request: pull_request} do
      conn = put(conn, Routes.pull_request_path(conn, :update, pull_request), pull_request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete pull_request" do
    setup [:create_pull_request]

    test "deletes chosen pull_request", %{conn: conn, pull_request: pull_request} do
      conn = delete(conn, Routes.pull_request_path(conn, :delete, pull_request))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.pull_request_path(conn, :show, pull_request))
      end
    end
  end

  defp create_pull_request(_) do
    pull_request = fixture(:pull_request)
    {:ok, pull_request: pull_request}
  end
end
