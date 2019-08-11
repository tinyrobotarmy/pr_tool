defmodule PrTool.PullRequests.PullRequestManager do
  alias PrTool.{GithubClient, PullRequests}

  def load_pulls(git_repo, username, password) do
    git_repo
    |> GithubClient.get_pulls(username, password)
    |> Enum.each(&find_or_create_pr(&1, username, password, git_repo))
  end

  defp find_or_create_pr(shallow_pr, username, password, git_repo) do
    case PullRequests.find_pull_request_by_external(git_repo.id, shallow_pr.id) do
      nil -> create_pr(shallow_pr, username, password, git_repo)
      existing -> refresh_unmerged(existing, shallow_pr, username, password, git_repo)
    end
  end

  defp create_pr(shallow_pr, username, password, git_repo) do
    shallow_pr.url
    |> GithubClient.get_detail(username, password)
    |> PullRequests.attrs_from_github_pr(git_repo.id)
    |> PullRequests.create_pull_request
  end

  defp refresh_unmerged(existing, shallow_pr, username, password, git_repo) do
    case existing.merged_at == nil do
      true ->
        PullRequests.delete_pull_request(existing)
        create_pr(shallow_pr, username, password, git_repo)
      false -> existing
    end
  end
end
