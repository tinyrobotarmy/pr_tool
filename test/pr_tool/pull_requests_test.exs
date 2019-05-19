defmodule PrTool.PullRequestsTest do
  use PrTool.DataCase

  alias PrTool.PullRequests

  describe "pull_requests" do
    alias PrTool.PullRequests.PullRequest

    @valid_attrs %{additions: 42, author: "some author", changed_files: 42, comments: 42, commits: 42, days_to_merge: 42, deletions: 42, reviewers: 42, title: "some title"}
    @update_attrs %{additions: 43, author: "some updated author", changed_files: 43, comments: 43, commits: 43, days_to_merge: 43, deletions: 43, reviewers: 43, title: "some updated title"}
    @invalid_attrs %{additions: nil, author: nil, changed_files: nil, comments: nil, commits: nil, days_to_merge: nil, deletions: nil, reviewers: nil, title: nil}

    def pull_request_fixture(attrs \\ %{}) do
      {:ok, pull_request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PullRequests.create_pull_request()

      pull_request
    end

    test "list_pull_requests/0 returns all pull_requests" do
      pull_request = pull_request_fixture()
      assert PullRequests.list_pull_requests() == [pull_request]
    end

    test "get_pull_request!/1 returns the pull_request with given id" do
      pull_request = pull_request_fixture()
      assert PullRequests.get_pull_request!(pull_request.id) == pull_request
    end

    test "create_pull_request/1 with valid data creates a pull_request" do
      assert {:ok, %PullRequest{} = pull_request} = PullRequests.create_pull_request(@valid_attrs)
      assert pull_request.additions == 42
      assert pull_request.author == "some author"
      assert pull_request.changed_files == 42
      assert pull_request.comments == 42
      assert pull_request.commits == 42
      assert pull_request.days_to_merge == 42
      assert pull_request.deletions == 42
      assert pull_request.reviewers == 42
      assert pull_request.title == "some title"
    end

    test "create_pull_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PullRequests.create_pull_request(@invalid_attrs)
    end

    test "update_pull_request/2 with valid data updates the pull_request" do
      pull_request = pull_request_fixture()
      assert {:ok, %PullRequest{} = pull_request} = PullRequests.update_pull_request(pull_request, @update_attrs)
      assert pull_request.additions == 43
      assert pull_request.author == "some updated author"
      assert pull_request.changed_files == 43
      assert pull_request.comments == 43
      assert pull_request.commits == 43
      assert pull_request.days_to_merge == 43
      assert pull_request.deletions == 43
      assert pull_request.reviewers == 43
      assert pull_request.title == "some updated title"
    end

    test "update_pull_request/2 with invalid data returns error changeset" do
      pull_request = pull_request_fixture()
      assert {:error, %Ecto.Changeset{}} = PullRequests.update_pull_request(pull_request, @invalid_attrs)
      assert pull_request == PullRequests.get_pull_request!(pull_request.id)
    end

    test "delete_pull_request/1 deletes the pull_request" do
      pull_request = pull_request_fixture()
      assert {:ok, %PullRequest{}} = PullRequests.delete_pull_request(pull_request)
      assert_raise Ecto.NoResultsError, fn -> PullRequests.get_pull_request!(pull_request.id) end
    end

    test "change_pull_request/1 returns a pull_request changeset" do
      pull_request = pull_request_fixture()
      assert %Ecto.Changeset{} = PullRequests.change_pull_request(pull_request)
    end
  end
end
