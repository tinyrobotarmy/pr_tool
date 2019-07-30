defmodule PrTool.PullRequestsTest do
  use PrTool.DataCase

  alias PrTool.PullRequests
  alias PrTool.PullRequests.PullRequest

  @invalid_attrs %{additions: nil, author: nil, changed_files: nil, comments: nil, commits: nil, days_to_merge: nil, deletions: nil, reviewers: nil, title: nil}

  describe "list_pull_requests/0" do
    setup [:single_pr]

    test "returns all pull_requests", %{pr: pr} do
      assert PullRequests.list_pull_requests() == [pr]
    end
  end

  describe "get_pull_request!/1" do
    setup [:single_pr]

    test "returns the pull_request with given id", %{pr: pr} do
      assert PullRequests.get_pull_request!(pr.id) == pr
    end
  end

  describe "find_pull_request_by_external_id" do
    setup [:single_pr]

    test "returns the pull_request with given id", %{pr: pr} do
      assert PullRequests.find_pull_request_by_external(pr.git_repo_id, pr.external_id) == pr
    end
  end

  describe "create_pull_request/1" do
    setup [:single_git_repo]

    test "with valid data creates a pull_request", %{git_repo: git_repo} do
      attrs = Map.merge(Factory.all_pull_request_attributes(), %{"git_repo_id" => git_repo.id})
      assert {:ok, %PullRequest{} = pull_request} = PullRequests.create_pull_request(attrs)
      assert pull_request.additions == attrs["additions"]
      assert pull_request.author == attrs["author"]
      assert pull_request.changed_files == attrs["changed_files"]
      assert pull_request.comments == attrs["comments"]
      assert pull_request.commits == attrs["commits"]
      assert pull_request.days_to_merge == attrs["days_to_merge"]
      assert pull_request.deletions == attrs["deletions"]
      assert pull_request.reviewers == attrs["reviewers"]
      assert pull_request.title == attrs["title"]
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PullRequests.create_pull_request(@invalid_attrs)
    end
  end

  describe "update_pull_request/2" do
    setup [:single_pr]

    test "with valid data updates the pull_request", %{pr: pr} do
      attrs = Factory.all_pull_request_attributes()
      assert {:ok, %PullRequest{} = pr} = PullRequests.update_pull_request(pr, attrs)
      assert pr.additions == attrs["additions"]
      assert pr.author == attrs["author"]
      assert pr.changed_files == attrs["changed_files"]
      assert pr.comments == attrs["comments"]
      assert pr.commits == attrs["commits"]
      assert pr.days_to_merge == attrs["days_to_merge"]
      assert pr.deletions == attrs["deletions"]
      assert pr.reviewers == attrs["reviewers"]
      assert pr.title == attrs["title"]
    end

    test "with invalid data returns error changeset", %{pr: pr} do
      assert {:error, %Ecto.Changeset{}} = PullRequests.update_pull_request(pr, @invalid_attrs)
      assert pr == PullRequests.get_pull_request!(pr.id)
    end
  end

  describe "delete_pull_request/1" do
    setup [:single_pr]

    test "deletes the pull_request", %{pr: pr} do
      assert {:ok, %PullRequest{}} = PullRequests.delete_pull_request(pr)
      assert_raise Ecto.NoResultsError, fn -> PullRequests.get_pull_request!(pr.id) end
    end
  end

  describe "change_pull_request/1" do
    setup [:single_pr]

    test "returns a pull_request changeset", %{pr: pr} do
      assert %Ecto.Changeset{} = PullRequests.change_pull_request(pr)
    end
  end

  describe "as_time_series/1" do
    setup [:three_prs]

    test "series contains an entry for each month with an item in it from the first", %{git_repo: git_repo} do
      series = PullRequests.as_time_series(git_repo.id)
      assert 2 == Enum.count(series)
    end

    test "groups prs correctly", %{git_repo: git_repo} do
      series = PullRequests.as_time_series(git_repo.id)
      assert 1 == Enum.count(hd(Map.values(Enum.at(series,0))))
      assert 2 == Enum.count(hd(Map.values(Enum.at(series,1))))
    end
  end

  describe "process_for_average/2 on days_to_merge" do
    setup [:three_prs]

    test "series contains x with value of date", %{git_repo: git_repo, pr_1: pr_1} do
      series = git_repo.id
        |> PullRequests.as_time_series()
        |> PullRequests.process_for_average(:days_to_merge)
      assert Timex.shift(pr_1.merged_at, months: 1) == hd(series).x
    end

    test "series contains y with average of days to merge", %{git_repo: git_repo, pr_1: pr_1} do
      series = git_repo.id
        |> PullRequests.as_time_series()
        |> PullRequests.process_for_average(:days_to_merge)
      assert pr_1.days_to_merge == hd(series).y
    end
  end

  describe "process_for_average/2 on changed_files" do
    setup [:three_prs]

    test "series contains x with value of date", %{git_repo: git_repo, pr_1: pr_1} do
      series = git_repo.id
        |> PullRequests.as_time_series()
        |> PullRequests.process_for_average(:changed_files)
      assert Timex.shift(pr_1.merged_at, months: 1) == hd(series).x
    end

    test "series contains y with average of files changed", %{git_repo: git_repo, pr_1: pr_1} do
      series = git_repo.id
        |> PullRequests.as_time_series()
        |> PullRequests.process_for_average(:changed_files)
      assert pr_1.changed_files == hd(series).y
    end
  end

  describe "process_field_pair_for_average/3 on additions and deletions" do
    setup [:three_prs]

    test "series contains x with value of date", %{git_repo: git_repo, pr_1: pr_1} do
      series = git_repo.id
        |> PullRequests.as_time_series()
        |> PullRequests.process_field_pair_for_average(:additions, :deletions)
      assert Timex.shift(pr_1.merged_at, months: 1) == hd(series).x
    end

    test "series contains y with average of days to merge", %{git_repo: git_repo, pr_1: pr_1} do
      series = git_repo.id
        |> PullRequests.as_time_series()
        |> PullRequests.process_field_pair_for_average(:additions, :deletions)
      assert pr_1.additions + pr_1.deletions == hd(series).y
    end
  end

  defp single_git_repo(_context) do
    git_repo = Factory.create_git_repo()
    [git_repo: git_repo]
  end

  defp single_pr(_context) do
    pr = Factory.create_pull_request()
    [pr: pr]
  end

  defp three_prs(_context) do
    git_repo = Factory.create_git_repo
    pr_1 = Factory.create_pull_request(%{"git_repo_id" => git_repo.id, "merged_at" => Timex.shift(DateTime.utc_now(), months: -3)})
    Factory.create_pull_request(%{"git_repo_id" => git_repo.id, "merged_at" => Timex.shift(DateTime.utc_now(), months: -1)})
    Factory.create_pull_request(%{"git_repo_id" => git_repo.id, "merged_at" => Timex.shift(DateTime.utc_now(), months: -1)})
    [git_repo: git_repo, pr_1: pr_1]
  end
end
