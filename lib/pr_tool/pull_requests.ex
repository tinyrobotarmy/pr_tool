defmodule PrTool.PullRequests do
  @moduledoc """
  The PullRequests context.
  """

  import Ecto.Query, warn: false
  alias PrTool.Repo

  alias PrTool.PullRequests.PullRequest

  @doc """
  Returns the list of pull_requests.

  ## Examples

      iex> list_pull_requests()
      [%PullRequest{}, ...]

  """
  def list_pull_requests do
    Repo.all(PullRequest)
  end

  @doc """
  Gets a single pull_request.

  Raises `Ecto.NoResultsError` if the Pull request does not exist.

  ## Examples

      iex> get_pull_request!(123)
      %PullRequest{}

      iex> get_pull_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pull_request!(id), do: Repo.get!(PullRequest, id)

  @doc """
  Creates a pull_request.

  ## Examples

      iex> create_pull_request(%{field: value})
      {:ok, %PullRequest{}}

      iex> create_pull_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pull_request(attrs \\ %{}) do
    %PullRequest{}
    |> PullRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pull_request.

  ## Examples

      iex> update_pull_request(pull_request, %{field: new_value})
      {:ok, %PullRequest{}}

      iex> update_pull_request(pull_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pull_request(%PullRequest{} = pull_request, attrs) do
    pull_request
    |> PullRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PullRequest.

  ## Examples

      iex> delete_pull_request(pull_request)
      {:ok, %PullRequest{}}

      iex> delete_pull_request(pull_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pull_request(%PullRequest{} = pull_request) do
    Repo.delete(pull_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pull_request changes.

  ## Examples

      iex> change_pull_request(pull_request)
      %Ecto.Changeset{source: %PullRequest{}}

  """
  def change_pull_request(%PullRequest{} = pull_request) do
    PullRequest.changeset(pull_request, %{})
  end
end
