defmodule PrTool.PullRequests.PullRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pull_requests" do
    field :additions, :integer
    field :author, :string
    field :changed_files, :integer
    field :comments, :integer
    field :commits, :integer
    field :days_to_merge, :integer
    field :deletions, :integer
    field :reviewers, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(pull_request, attrs) do
    pull_request
    |> cast(attrs, [:title, :author, :reviewers, :commits, :comments, :changed_files, :additions, :deletions, :days_to_merge])
    |> validate_required([:title, :author, :reviewers, :commits, :comments, :changed_files, :additions, :deletions])
  end
end
