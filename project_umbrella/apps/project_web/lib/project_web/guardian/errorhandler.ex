defmodule ProjectWeb.ErrorHandler do
    import Plug.Conn
    alias Phoenix.Controller
    import ProjectWeb.Gettext

    @behaviour Guardian.Plug.ErrorHandler
  
    @impl Guardian.Plug.ErrorHandler
    def auth_error(conn, {_type, _reason}, _opts) do
      conn
      |> Controller.put_flash(:error, gettext "Unauthorized access")
      |> Controller.redirect(to: "/")
      |> halt
    end
  end