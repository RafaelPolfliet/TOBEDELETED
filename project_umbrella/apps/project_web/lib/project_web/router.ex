defmodule ProjectWeb.Router do
  use ProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ProjectWeb.Plugs.Locale
  end

  pipeline :allowed_for_users do
    plug ProjectWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug ProjectWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  pipeline :auth do
    plug ProjectWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api_auth_write do
    plug ProjectWeb.Plugs.ApiKeyPlug, true
  end

  pipeline :api_auth_non_write do
    plug ProjectWeb.Plugs.ApiKeyPlug, false
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ProjectWeb do
    pipe_through [:browser, :auth]

    get "/", SessionController, :new
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/signup", UserController, :new
    post "/signup", UserController, :create
    
  end

  scope "/", ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/dashboard", AnimalController, :index_web
    get "/profile", UserController, :show
    get "/change/:id", UserController, :edit
    get "/change_username", UserController, :change_username
    put "/change_username", UserController, :current_username_update
    get "/change_password", UserController, :change_password
    put "/change_password", UserController, :current_password_update
    post "/newApiKey", ApiController, :create
    get "/profile/apikeys/:id",ApiController, :show
    delete "/profile/apikeys/:id",ApiController, :delete
    get "/verfiy/:user_id/:key_id",ApiController, :verify
  end

  scope "/", ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    get "/usermanagement", UserController, :index
    get "/edituser/:id", UserController, :edit
    put "/edituser/:id", UserController, :update
    delete "/deleteuser/:id", UserController, :delete
  
  end

  scope "/api", ProjectWeb do
    pipe_through [:api, :api_auth_non_write]

    resources "/users", UserController, only: [] do
      resources "/animals", AnimalController, only: [:index,:show]
    end
  end


  scope "/api", ProjectWeb do
    pipe_through [:api, :api_auth_write]

    resources "/users", UserController, only: [] do
      resources "/animals", AnimalController, only: [:create,:update,:delete]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProjectWeb do
  #   pipe_through :api
  # end
end
