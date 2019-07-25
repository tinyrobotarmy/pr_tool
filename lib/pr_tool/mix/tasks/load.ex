defmodule Mix.Tasks.Load do

  use Mix.Task
  alias PrTool.{CommandLine, GithubClient, PullRequests}
  alias PrTool.GitRepos

  def run(args) do
    Mix.Task.run "app.start"
    username = CommandLine.get_username
    password = CommandLine.get_password

    git_repo = args
    |> hd
    |> find_or_save_repo
    |> load_pulls(username, password)
  end

  defp find_or_save_repo(repo_name) do
    case GitRepos.get_git_repo_by_name(repo_name) do
      nil ->
        {:ok, git_repo} = GitRepos.create_git_repo(%{name: repo_name, url: repo_name})
        git_repo
      git_repo ->
        git_repo
    end
  end

  defp create_pr(shallow_pr, username, password, git_repo) do
    shallow_pr.url
    |> GithubClient.get_detail(username, password)
    |> PullRequests.attrs_from_github_pr(git_repo.id)
    |> PullRequests.create_pull_request
  end

  defp load_pulls(git_repo, username, password) do
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
