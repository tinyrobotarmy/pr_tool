defmodule Mix.Tasks.Load do

  use Mix.Task
  alias PrTool.CommandLine
  alias PrTool.GitRepos
  alias PrTool.PullRequests.PullRequestManager

  def run(args) do
    Mix.Task.run "app.start"
    username = CommandLine.get_username
    password = CommandLine.get_password

    git_repo = args
      |> hd
      |> find_or_save_repo
      |> PullRequestManager.load_pulls(username, password)
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
end
