defmodule ProjectWeb.AnimalController do
  use ProjectWeb, :controller

  alias Project.AnimalContext
  alias Project.AnimalContext.Animal

  def index(conn, _params) do
    animals = AnimalContext.list_animals()
    render(conn, "index.html", animals: animals)
  end

  def new(conn, _params) do
    changeset = AnimalContext.change_animal(%Animal{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"animal" => animal_params}) do
    case AnimalContext.create_animal(animal_params) do
      {:ok, animal} ->
        conn
        |> put_flash(:info, "Animal created successfully.")
        |> redirect(to: Routes.animal_path(conn, :show, animal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)
    render(conn, "show.html", animal: animal)
  end

  def edit(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)
    changeset = AnimalContext.change_animal(animal)
    render(conn, "edit.html", animal: animal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "animal" => animal_params}) do
    animal = AnimalContext.get_animal!(id)

    case AnimalContext.update_animal(animal, animal_params) do
      {:ok, animal} ->
        conn
        |> put_flash(:info, "Animal updated successfully.")
        |> redirect(to: Routes.animal_path(conn, :show, animal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", animal: animal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)
    {:ok, _animal} = AnimalContext.delete_animal(animal)

    conn
    |> put_flash(:info, "Animal deleted successfully.")
    |> redirect(to: Routes.animal_path(conn, :index))
  end
end
