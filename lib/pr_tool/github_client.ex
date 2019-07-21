defmodule PrTool.GithubClient do

  alias PrTool.LinkManager

  def get_pulls(git_repo, username, password) do
    HTTPoison.start
    git_repo.url
    |> request_all_url
    |> append_pulls([], get_opts(username, password))
  end

  def get_detail(url, username, password) do
    response = HTTPoison.get!(url, [], get_opts(username, password))
    Poison.decode!(response.body, keys: :atoms)
  end

  defp request_all_url(repo_name) do
    "#{Application.get_env(:pr_tool, :github_api_url)}repos/#{repo_name}/pulls?state=all" |> IO.inspect
  end

  defp request_open_url(repo_name) do
    "#{Application.get_env(:pr_tool, :github_api_url)}repos/#{repo_name}/pulls"
  end

  defp append_pulls(nil, pulls, _opts), do: pulls
  defp append_pulls(url, pulls, opts) do
    response = HTTPoison.get!(url, [], opts)
    new_pulls = Poison.decode!(response.body, keys: :atoms)
    append_pulls(LinkManager.get_next_link(response.headers), pulls ++ new_pulls, opts)
  end

  defp get_opts(username, password) do
    [hackney: [:insecure, basic_auth: {username, password}, timeout: 50_000, recv_timeout: 50_000]]
  end

end
