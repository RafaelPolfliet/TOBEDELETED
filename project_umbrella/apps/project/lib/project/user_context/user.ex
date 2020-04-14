defmodule Project.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Project.AnimalContext.Animal

  @acceptable_roles ["Admin","User"]

  schema "users" do
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, :string, default: "User"
    field :username, :string

    has_many :animals, Animal

  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> unique_constraint([:username])
    |> validate_required([:username, :password, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
    |> validate_confirmation(:password, message: "Passwords do not match")
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
