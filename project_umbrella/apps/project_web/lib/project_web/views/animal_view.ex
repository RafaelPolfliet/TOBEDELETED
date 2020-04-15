defmodule ProjectWeb.AnimalView do
  use ProjectWeb, :view

  alias ProjectWeb.AnimalView
  

  def render("index.json", %{animals: animals}) do
    %{data: render_many(animals, AnimalView, "all_animals.json")}
  end

  def render("show.json", %{animal: animal}) do
    %{data: render_one(animal, AnimalView, "animal.json")}
  end

  def render("all_animals.json", %{animal: animal}) do
    %{id: animal.id, name: animal.name}
  end

  def render("animal.json", %{animal: animal}) do
    %{id: animal.id, name: animal.name, date_of_birth: animal.date_of_birth, type: animal.type}
  end

  
end
