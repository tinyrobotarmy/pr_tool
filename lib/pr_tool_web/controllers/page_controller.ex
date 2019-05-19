defmodule PrToolWeb.PageController do
  use PrToolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
