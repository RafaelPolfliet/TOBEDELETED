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
      key = APIContext.get_api!(api_id).api_key
      text conn, key
    end



    def delete(conn, %{"id" => id}) do
      api = APIContext.get_api!(id)
      {:ok, _user} = APIContext.delete_api(api)
  
      conn
      |> put_flash(:info, gettext "API-Key succesfully revoked")
      |> redirect(to: Routes.user_path(conn, :show))
    end

end

