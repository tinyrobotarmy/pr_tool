defmodule PrTool.PullRequests.PullRequestManager do
  alias PrTool.{GithubClient, PullRequests}

  def load_pulls(git_repo, username, password) do
    git_repo
    |> GithubClient.get_pulls(username, password)
    |> Enum.each(&create_pr(&1, username, password, git_repo))
  end

  defp create_pr(shallow_pr, username, password, git_repo) do
    shallow_pr.url
    |> GithubClient.get_detail(username, password)
    |> PullRequests.attrs_from_github_pr(git_repo.id)
    |> PullRequests.create_pull_request
  end
end
