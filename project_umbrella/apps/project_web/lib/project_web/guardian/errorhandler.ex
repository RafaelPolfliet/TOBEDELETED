defmodule ProjectWeb.ErrorHandler do
    import Plug.Conn
    alias Phoenix.Controller

    @behaviour Guardian.Plug.ErrorHandler
  
    @impl Guardian.Plug.ErrorHandler
    def auth_error(conn, {type, _reason}, _opts) do
      conn
      |> Controller.put_flash(:error, "Unauthorized access")
      |> Controller.redirect(to: "/")
      |> halt
    end
  end