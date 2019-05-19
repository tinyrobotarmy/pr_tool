defmodule PrTool.FormatHelper do

  def days_between(_from_string, nil), do: nil
  def days_between(from_string, to_string) do
    {:ok, from, _} = DateTime.from_iso8601(from_string)
    {:ok, to, _} = DateTime.from_iso8601(to_string)
    to
    |> Timex.diff(from, :days)
    |> format_duration
  end

  def label_names(pull) do
    Enum.map(pull.labels, fn(label) -> label.name end)
  end

  defp format_duration(days) do
    case days do
      0 -> 1
      _ -> days
    end
  end
end
