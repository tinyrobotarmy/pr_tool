defmodule PrTool.PullRequests.PullRequest do
  use Ecto.Schema
  import Ecto.Changeset

  alias PrTool.PullRequests.PullRequest
  alias PrTool.GitRepos.GitRepo

  schema "pull_requests" do
    field :external_id, :integer
    field :additions, :integer
    field :author, :string
    field :changed_files, :integer
    field :comments, :integer
    field :commits, :integer
    field :days_to_merge, :integer
    field :deletions, :integer
    field :reviewers, :integer
    field :title, :string
    field :created_at, :utc_datetime
    field :closed_at, :utc_datetime
    field :merged_at, :utc_datetime

    belongs_to :git_repo, GitRepo

    timestamps()
  end

  @required_fields [:external_id, :title, :author, :reviewers, :commits, :comments, :changed_files, :additions, :deletions,
                    :git_repo_id, :created_at, :closed_at, :merged_at]

  @optional_fields [:days_to_merge]

  @doc false
  def changeset(%PullRequest{} = pull_request, attrs) do
    pull_request
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:git_repo_id)
  end
end
