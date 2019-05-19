defmodule PrToolWeb.PullRequestView do
  use PrToolWeb, :view
  alias PrToolWeb.PullRequestView

  def render("index.json", %{pull_requests: pull_requests}) do
    %{data: render_many(pull_requests, PullRequestView, "pull_request.json")}
  end

  def render("show.json", %{pull_request: pull_request}) do
    %{data: render_one(pull_request, PullRequestView, "pull_request.json")}
  end

  def render("pull_request.json", %{pull_request: pull_request}) do
    %{id: pull_request.id,
      title: pull_request.title,
      author: pull_request.author,
      reviewers: pull_request.reviewers,
      commits: pull_request.commits,
      comments: pull_request.comments,
      changed_files: pull_request.changed_files,
      additions: pull_request.additions,
      deletions: pull_request.deletions,
      days_to_merge: pull_request.days_to_merge}
  end
end
