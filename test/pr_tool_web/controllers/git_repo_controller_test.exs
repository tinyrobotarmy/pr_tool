defmodule PrToolWeb.GitRepoControllerTest do
  use PrToolWeb.ConnCase

  alias PrTool.GitRepos
  alias PrTool.GitRepos.GitRepo

  @invalid_attrs %{name: nil, url: nil}

  def fixture(:git_repo) do
    {:ok, git_repo} = GitRepos.create_git_repo(Factory.all_git_repo_attributes())
    git_repo
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all git_repos", %{conn: conn} do
      conn = get(conn, Routes.git_repo_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create git_repo" do
    test "renders git_repo when data is valid", %{conn: conn} do
      attrs = Map.merge(%{"username" => "test", "password" => "test", }, Factory.all_git_repo_attributes())
      conn = post(conn, Routes.git_repo_path(conn, :create), git_repo: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.git_repo_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => attrs["name"],
               "url" => attrs["url"],
               "changed_files_series" => [],
               "changes_series" => [],
               "comments_series" => [],
               "merged_series" => [],
               "pull_requests" => [],
               "reviewers_series" => [],
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = Map.merge(%{"username" => "test", "password" => "test", }, @invalid_attrs)
      conn = post(conn, Routes.git_repo_path(conn, :create), git_repo: attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update git_repo" do
    setup [:create_git_repo]

    test "renders git_repo when data is valid", %{conn: conn, git_repo: %GitRepo{id: id} = git_repo} do
      attrs = Factory.all_git_repo_attributes()
      conn = put(conn, Routes.git_repo_path(conn, :update, git_repo), git_repo: attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.git_repo_path(conn, :show, id))

      assert %{
        "id" => id,
        "name" => attrs["name"],
        "url" => attrs["url"],
        "changed_files_series" => [],
        "changes_series" => [],
        "comments_series" => [],
        "merged_series" => [],
        "pull_requests" => [],
        "reviewers_series" => [],
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, git_repo: git_repo} do
      conn = put(conn, Routes.git_repo_path(conn, :update, git_repo), git_repo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete git_repo" do
    setup [:create_git_repo]

    test "deletes chosen git_repo", %{conn: conn, git_repo: git_repo} do
      conn = delete(conn, Routes.git_repo_path(conn, :delete, git_repo))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.git_repo_path(conn, :show, git_repo))
      end
    end
  end

  defp create_git_repo(_) do
    git_repo = fixture(:git_repo)
    {:ok, git_repo: git_repo}
  end
end
