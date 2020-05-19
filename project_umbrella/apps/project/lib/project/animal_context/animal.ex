defmodule Project.AnimalContext.Animal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Project.UserContext.User

  @acceptable_types ["Dog","Cat"]

  schema "animals" do
    field :date_of_birth, :date
    field :name, :string
    field :type, :string
    belongs_to :user, User
  
  end

  def get_acceptable_types, do: @acceptable_types

  @doc false
  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [:name, :date_of_birth, :type])
    |> validate_required([:name, :date_of_birth, :type])
    |> validate_inclusion(:type, @acceptable_types, message: "Animals can only be of type 'Cat' or 'Dog'")
  end

  def create_changeset(animal, attrs,user) do
    animal
    |> cast(attrs, [:name, :date_of_birth, :type])
    |> validate_required([:name, :date_of_birth, :type])
    |> validate_inclusion(:type, @acceptable_types, message: "Animals can only be of type 'Cat' or 'Dog'")
    |> put_assoc(:user,user)
  end
end    
