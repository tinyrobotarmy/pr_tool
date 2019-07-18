defmodule PrToolWeb.GitRepoView do
  use PrToolWeb, :view
  alias PrToolWeb.GitRepoView

  def render("index.json", %{git_repos: git_repos}) do
    %{
      data: git_repos_json(git_repos)
    }
  end

  def render("show.json", %{git_repo: git_repo, merged_series: merged_series, changed_files_series: changed_files_series,
                            changes_series: changes_series, comments_series: comments_series,
                            reviewers_series: reviewers_series}) do
    %{data:
      %{
        id: git_repo.id,
        name: git_repo.name,
        url: git_repo.url,
        pull_requests: pull_requests_json(git_repo.pull_requests),
        merged_series: merged_series,
        changed_files_series: changed_files_series,
        changes_series: changes_series,
        comments_series: comments_series,
        reviewers_series: reviewers_series,
      }
    }
  end

  def render("summary.json", %{git_repo: git_repo}) do
    %{data: %{id: git_repo.id}}
  end

  def git_repos_json([]), do: []
  def git_repos_json(git_repos), do: Enum.map(git_repos, &git_repo_summary_json/1)

  def git_repo_summary_json(git_repo) do
    %{
      id: git_repo.id,
      name: git_repo.name,
      url: git_repo.url
    }
  end

  def pull_requests_json([]), do: []
  def pull_requests_json(pull_requests), do: Enum.map(pull_requests, &pull_request_json/1)

  def pull_request_json(pull) do
    %{
      external_id: pull.external_id,
      title: pull.title,
      author: pull.author,
      days_to_merge: pull.days_to_merge,
      changed_files: pull.changed_files,
      closed_at: pull.closed_at,
      merged_at: pull.merged_at,
    }
  end
end
