defmodule PrTool.GitRepos do
  @moduledoc """
  The GitRepos context.
  """

  import Ecto.Query, warn: false
  alias PrTool.Repo

  alias PrTool.GitRepos.GitRepo

  @doc """
  Returns the list of git_repos.

  ## Examples

      iex> list_git_repos()
      [%GitRepo{}, ...]

  """
  def list_git_repos do
    Repo.all(GitRepo)
  end

  @doc """
  Gets a single git_repo.

  Raises `Ecto.NoResultsError` if the Git repo does not exist.

  ## Examples

      iex> get_git_repo!(123)
      %GitRepo{}

      iex> get_git_repo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_git_repo!(id) do
    GitRepo
    |> Repo.get!(id)
    |> Repo.preload([:pull_requests])
  end

  def get_git_repo_by_name(name), do: Repo.get_by(GitRepo, name: name)

  @doc """
  Creates a git_repo.

  ## Examples

      iex> create_git_repo(%{field: value})
      {:ok, %GitRepo{}}

      iex> create_git_repo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_git_repo(attrs \\ %{}) do
    %GitRepo{}
    |> GitRepo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a git_repo.

  ## Examples

      iex> update_git_repo(git_repo, %{field: new_value})
      {:ok, %GitRepo{}}

      iex> update_git_repo(git_repo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_git_repo(%GitRepo{} = git_repo, attrs) do
    git_repo
    |> GitRepo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GitRepo.

  ## Examples

      iex> delete_git_repo(git_repo)
      {:ok, %GitRepo{}}

      iex> delete_git_repo(git_repo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_git_repo(%GitRepo{} = git_repo) do
    Repo.delete(git_repo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking git_repo changes.

  ## Examples

      iex> change_git_repo(git_repo)
      %Ecto.Changeset{source: %GitRepo{}}

  """
  def change_git_repo(%GitRepo{} = git_repo) do
    GitRepo.changeset(git_repo, %{})
  end
end
