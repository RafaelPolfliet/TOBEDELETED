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

  pipeline :api_auth do
    plug ProjectWeb.Plugs.ApiKeyPlug
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
    resources "/user", UserController, only: [] do
      resources "/animals", AnimalController
    end
  end

  scope "/", ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/dashboard", AnimalController, :index_web
    get "/profile", UserController, :show
    get "/change_username/:id", UserController, :edit
    put "/change_username", UserController, :update
    post "/newApiKey", ApiController, :create
    get "/profile/apikeys/:id",ApiController, :show
    delete "/profile/apikeys/:id",ApiController, :delete
    get "/verfiy/:user_id/:key_id",ApiController, :verify
  end

  scope "/", ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    get "/usermanagement", UserController, :index
    get "/edituser/:id", UserController, :edit
    delete "/deleteuser/:id", UserController, :delete
  
  end

  scope "/api", ProjectWeb do
    pipe_through [:api, :api_auth]


    resources "/users", UserController, only: [] do
      resources "/animals", AnimalController, only: [:index,:show,:create,:update,:delete]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProjectWeb do
  #   pipe_through :api
  # end
end
