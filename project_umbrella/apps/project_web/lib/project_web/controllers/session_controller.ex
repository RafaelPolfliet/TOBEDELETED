defmodule ProjectWeb.SessionController do
  use ProjectWeb, :controller

  alias ProjectWeb.Guardian
  alias Project.UserContext
  alias Project.UserContext.User

  def new(conn, _) do
    changeset = UserContext.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/dashboard")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    UserContext.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, gettext "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/dashboard")
  end

  defp login_reply({:error, _reason}, conn) do
    conn
    |> put_flash(:error, gettext "Invalid credentials")
    |> new(%{})
  end
end