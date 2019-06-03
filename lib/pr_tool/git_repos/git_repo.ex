defmodule PrTool.GitRepos.GitRepo do
  use Ecto.Schema
  import Ecto.Changeset

  alias PrTool.PullRequests.PullRequest
  alias PrTool.GitRepos.GitRepo

  schema "git_repos" do
    field :name, :string
    field :url, :string

    has_many :pull_requests, PullRequest

    timestamps()
  end

  @required_fields [:name, :url]

  @optional_fields []

  @doc false
  def changeset(%GitRepo{} = git_repo, attrs) do
    git_repo
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:pull_requests, required: false)
  end
end
