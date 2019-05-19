defmodule PrTool.CommandLine do

  def get_username do
    "enter your git username: "
    |> Mix.Shell.IO.prompt
    |> String.trim
  end

  def get_password do
    "Password: "
    |> password_get
    |> String.trim
  end

  # Password prompt that hides input by every 1ms
  # clearing the line with stderr
  def password_get(prompt) do
    pid = spawn_link fn -> loop(prompt) end
    ref = make_ref()

    value = IO.gets(prompt <> " ")

    send pid, {:done, self(), ref}
    receive do: ({:done, ^pid, ^ref}  -> :ok)

    value
  end

  defp loop(prompt) do
    receive do
      {:done, parent, ref} ->
        send parent, {:done, self, ref}
        IO.write :standard_error, "\e[2K\r"
    after
      1 ->
        IO.write :standard_error, "\e[2K\r#{prompt} "
        loop(prompt)
    end
  end
end
