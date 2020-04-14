defmodule ProjectWeb.PageController do
  use ProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", role: "everyone")
  end
end
