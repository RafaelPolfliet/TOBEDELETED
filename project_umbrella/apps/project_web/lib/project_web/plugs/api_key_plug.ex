defmodule ProjectWeb.Plugs.ApiKeyPlug do
 
    def init(options), do: options
  
    def call(conn,_) do
        key = List.first(Plug.Conn.get_req_header(conn,"myfancyheader"))
        id = Map.get(Plug.Conn.fetch_query_params(conn).params, "user_id")
        conn
          |> verify(key,id)
       
    end


    def verify(conn,key,user_id) do
        user_id = String.to_integer(user_id)
        case Phoenix.Token.verify(ProjectWeb.Endpoint,"userAPIkey",key, max_age: :infinity) do
          {:ok,^user_id} ->
                conn
          {_, _} ->
                Plug.Conn.send_resp(conn,401,"Permission Denied!")

       end
  end
  end