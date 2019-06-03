defmodule PrTool.Repo do
  alias Ecto.{
    Query
  }
  require Ecto.Query
  use Ecto.Repo,
    otp_app: :pr_tool,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Returns a the number of records that exist in the database for the passed in schema
  """
  def count(schema) do
    query = Query.from(s in schema, select: count("*"))
    __MODULE__.one(query)
  end

  @doc """
  Returns the last created record for the given schema
  """
  def last(schema) do
    schema
    |> Query.last()
    |> __MODULE__.one()
  end

  @doc """
  Returns the first created record for the given schema
  """
  def first(schema) do
    schema
    |> Query.first()
    |> __MODULE__.one()
  end

  def format_result(result) do
    case result do
      nil ->
        {:error, :not_found}
      result ->
        {:ok, result}
    end
  end
end
