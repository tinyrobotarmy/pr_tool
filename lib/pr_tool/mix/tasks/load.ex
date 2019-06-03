defmodule Mix.Tasks.Load do

  use Mix.Task
  alias PrTool.{CommandLine, FormatHelper, GithubClient, PullRequests}
  alias PrTool.GitRepos

  def run(args) do
    Mix.Task.run "app.start"
    username = CommandLine.get_username
    password = CommandLine.get_password

    git_repo = args
    |> hd
    |> save_repo

    git_repo
    |> GithubClient.get_pulls(username, password)
    |> Enum.each(&create_pr(&1, username, password, git_repo))
  end

  defp save_repo(repo_name) do
    {:ok, git_repo} = GitRepos.create_git_repo(%{name: repo_name, url: repo_name})
    git_repo
  end

  defp create_pr(shallow_pr, username, password, git_repo) do
    shallow_pr.url
    |> GithubClient.get_detail(username, password)
    |> pr_attrs(git_repo)
    |> PullRequests.create_pull_request
  end

  defp pr_attrs(pull, git_repo) do
    %{
      external_id: pull.id,
      created_at: pull.created_at,
      closed_at: pull.closed_at,
      merged_at: pull.merged_at,
      git_repo_id: git_repo.id,
      title: pull.title,
      author: pull.user.login,
      labels: FormatHelper.label_names(pull),
      reviewers: Enum.count(pull.requested_reviewers),
      commits: pull.commits,
      comments: pull.comments,
      changed_files: pull.changed_files,
      additions: pull.additions,
      deletions: pull.deletions,
      days_to_merge: FormatHelper.days_between(pull.created_at, pull.merged_at),
    }
  end
end
