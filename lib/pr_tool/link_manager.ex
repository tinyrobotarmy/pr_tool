defmodule PrTool.LinkManager do
  def get_next_link(headers) do
    row = Enum.find(headers, fn x -> elem(x,0) == "Link" end)
    case row do
      nil ->
        nil
      tuple ->
        link = elem(tuple, 1)
        ~r/(https:\/\/\S*?)>; rel=\"next\"/
        |> Regex.run(link)
        |> get_link
    end
  end

  defp get_link(nil), do: nil
  defp get_link(links), do: List.last(links)
end
