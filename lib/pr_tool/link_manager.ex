defmodule PrTool.LinkManager do
  def get_next_link(headers = [{"link", _links}]) do
    link = headers
      |> Enum.find(fn x -> elem(x,0) == "Link" end)
      |> elem(1)
    ~r/(https:\/\/\S*?)>; rel=\"next\"/
    |> Regex.run(link)
    |> get_link
  end
  def get_next_link(_headers), do: nil

  defp get_link(nil), do: nil
  defp get_link(links), do: List.last(links)

  defp get_opts(username, password) do
    [hackney: [:insecure, basic_auth: {username, password}]]
  end
end
