defmodule ProjectWeb.UserController do
  use ProjectWeb, :controller

  alias Project.UserContext
  alias Project.UserContext.User
  alias Project.APIContext.Api
  alias Project.APIContext


  def login(conn, _params) do
    render(conn, "login.html")
  end

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext "Your registration was succesfull - Please login")
        |> redirect(to: Routes.session_path(conn,:login))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    user = APIContext.load_users_apis(user)
    changeset = APIContext.change_api(%Api{})
    render(conn, "show.html", user: user,changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def change_username(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserContext.change_user(user)
    render(conn, "change_username.html", changeset: changeset)
  end

  def change_password(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserContext.change_user(user)
    render(conn, "change_password.html", changeset: changeset)
  end
  def current_username_update(conn, %{ "user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    case UserContext.update_username(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext "Username updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "change_username.html", user: user, changeset: changeset)
    end
  end

  
  def current_password_update(conn, %{ "user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    case UserContext.update_user_password(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext "Password updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "change_password.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{ "id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)
    case UserContext.update_user(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, gettext "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
