defmodule PrTool.Factory do

  alias Faker.{Internet, Lorem, Name}
  alias PrTool.{
    GitRepos.GitRepo,
    PullRequests.PullRequest,
    Repo
  }

def all_git_repo_attributes do
    %{
      "name" => Name.first_name(),
      "url" => Internet.url(),
    }
  end

  def create_git_repo(attrs \\ %{}) do
    all = Map.merge(all_git_repo_attributes(), attrs)

    %GitRepo{}
    |> GitRepo.changeset(all)
    |> Repo.insert!

    GitRepo
    |> Repo.last
  end

  def all_pull_request_attributes do
    %{
      "external_id" => :rand.uniform(5000),
      "additions" => :rand.uniform(5000),
      "author" => Name.name(),
      "changed_files" => :rand.uniform(50),
      "comments" => :rand.uniform(50),
      "commits" => :rand.uniform(50),
      "days_to_merge" => :rand.uniform(10),
      "deletions" => :rand.uniform(500),
      "reviewers" => :rand.uniform(5),
      "title" => Lorem.sentence(),
      "created_at" => Timex.shift(DateTime.utc_now(), days: -(:rand.uniform(20))),
      "closed_at" => Timex.shift(DateTime.utc_now(), days: -(:rand.uniform(5))),
      "merged_at" => Timex.shift(DateTime.utc_now(), days: -(:rand.uniform(5))),
    }
  end

  def create_pull_request(attrs \\ %{}) do
    all = all_pull_request_attributes()
      |> Map.merge(attrs)
      |> ensure_git_repo

    %PullRequest{}
    |> PullRequest.changeset(all)
    |> Repo.insert!
  end

  defp ensure_git_repo(%{"git_repo_id" => _git_repo_id} = attrs), do: attrs
  defp ensure_git_repo(attrs) do
    Map.merge(attrs, %{"git_repo_id" => create_git_repo().id})
  end
end
