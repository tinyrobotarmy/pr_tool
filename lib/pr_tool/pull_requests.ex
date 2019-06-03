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

  def list_pull_requests(git_repo_id) do
    git_repo_id
    |> list_pull_requests_query
    |> Repo.all
  end

  defp list_pull_requests_query(git_repo_id) do
    from pr in PullRequest,
      where: pr.git_repo_id == ^git_repo_id
  end

  def as_time_series(git_repo_id) do
    git_repo_id
    |> ordered_merged_pull_requests_query
    |> Repo.all
    |> group_by_month
  end

  defp ordered_merged_pull_requests_query(git_repo_id) do
    from pr in PullRequest,
      where: pr.git_repo_id == ^git_repo_id,
      where: not is_nil(pr.merged_at),
      order_by: [asc: pr.merged_at]
  end

  defp group_by_month(pulls) do
    keep_grouping(pulls, Timex.shift(hd(pulls).merged_at, months: 1), [])
  end

  defp keep_grouping(pulls, date, acc) do
    {merged_b4, remaining} = Enum.split_with(pulls, fn(pull) -> Timex.before?(pull.merged_at, date) end)
    grouped = Enum.concat(acc,[%{date => merged_b4}])
    case Enum.empty?(remaining) do
      true ->
        grouped
      false ->
        keep_grouping(remaining, Timex.shift(date, months: 1), grouped)
    end
  end

  def process_for_average(time_series) do
    Enum.map(time_series, fn(item) ->
      keys = Map.keys(item)
      values = Map.values(item)
      %{x: hd(keys), y: average(hd(values))}
    end)
  end

  defp average([]), do: nil
  defp average(pulls) do
    total = Enum.reduce(pulls, 0, fn(pull, acc) -> pull.days_to_merge + acc end)
    total / Enum.count(pulls)
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
