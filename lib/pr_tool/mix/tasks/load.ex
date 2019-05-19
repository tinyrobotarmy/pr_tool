defmodule Mix.Tasks.Load do

  use Mix.Task
  alias PrTool.{CommandLine, FormatHelper, GithubClient, PullRequests}

  def run(args) do
    Mix.Task.run "app.start"
    username = CommandLine.get_username
    password = CommandLine.get_password

    args
    |> hd
    |> GithubClient.get_pulls(username, password)
    |> Enum.each(&create_pr(&1, username, password))
  end

  defp create_pr(shallow_pr, username, password) do
    shallow_pr.url
    |> GithubClient.get_detail(username, password)
    |> pr_attrs
    |> IO.inspect
    |> PullRequests.create_pull_request
  end

  defp pr_attrs(pull) do
    %{
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
