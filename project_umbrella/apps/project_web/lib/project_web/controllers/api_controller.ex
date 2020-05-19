defmodule ProjectWeb.ApiController do
    use ProjectWeb, :controller

    alias Project.APIContext
  
    def create(conn, %{ "api" => api_params}) do

        user = Guardian.Plug.current_resource(conn)

        case APIContext.create_api(api_params,user) do
          {:ok, _user} ->
            conn
            |> put_flash(:info, gettext "API-Key created successfully.")
            |> redirect(to: Routes.user_path(conn,:show))
    
          {:error, _} ->
            conn
            |> put_flash(:error, gettext "API-Key needs a name")
            |> redirect(to: Routes.user_path(conn,:show))

          end
    end


    def show(conn, %{"id" => api_id}) do
      user = Guardian.Plug.current_resource(conn)

      case APIContext.get_api_for_user(api_id,user) do
        {:ok, api} ->
          text conn,  api.api_key
        {:error, _} ->
          text conn, "Permission denied"
        end


    end



    def delete(conn, %{"id" => id}) do
      user = Guardian.Plug.current_resource(conn)

      case APIContext.get_api_for_user(id,user) do
        {:ok, api} ->
          APIContext.delete_api(api)
          conn
          |> put_flash(:info, gettext "API-Key succesfully revoked")
          |> redirect(to: Routes.user_path(conn, :show))
        {:error, _} ->
          conn
          |> send_resp(401,"Permission Denied!")
        end
    end

end

