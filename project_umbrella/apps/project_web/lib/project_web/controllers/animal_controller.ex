defmodule ProjectWeb.AnimalController do
  use ProjectWeb, :controller

  alias Project.AnimalContext
  alias Project.AnimalContext.Animal
  alias Project.UserContext


  def index_web(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    userWithAnimals = AnimalContext.load_users_animals(user)
    animals = userWithAnimals.animals
    render(conn, "index.html", animals: animals)
  end

  def index(conn, %{"user_id" => user_id}) do
    user = UserContext.get_user!(user_id)
    userWithAnimals = AnimalContext.load_users_animals(user)
    animals = userWithAnimals.animals
    render(conn, "index.json", animals: animals)
  end


  def create(conn, %{"user_id" => user_id,"animal" => animal_params}) do

    user = UserContext.get_user!(user_id)

    case AnimalContext.create_animal(animal_params,user) do
      {:ok, animal} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_animal_path(conn,:show,user_id,animal))
          |> render("show.json",animal: animal)

      {:error, _} ->
        conn
        |> send_resp(400,  "Invalid api-request, adjust your parameters. Know that only animals of type 'Cat' or 'Dog' are allowed")
    end
  end

  def show(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)
    render(conn, "show.json", animal: animal)
  end

  def update(conn, %{"id" => id, "animal" => animal_params}) do
    animal = AnimalContext.get_animal!(id)

    case AnimalContext.update_animal(animal, animal_params) do
      {:ok, animal} ->
        render(conn,"show.json",animal: animal)

      {:error,_} ->
        conn
        |> send_resp(400,  "Invalid api-request, adjust your parameters. Know that only animals of type 'Cat' or 'Dog' are allowed")
    end
  end

  def delete(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)

    with {:ok, %Animal{}} <- AnimalContext.delete_animal(animal) do
      send_resp(conn, :no_content, "")
    end
  end

end
