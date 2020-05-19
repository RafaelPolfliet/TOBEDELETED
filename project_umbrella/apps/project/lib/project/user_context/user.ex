defmodule Project.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Project.AnimalContext.Animal
  alias Project.APIContext.Api

  @acceptable_roles ["Admin","User"]

  schema "users" do
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :current_password, :string, virtual: true
    field :password_previous, :string, virtual: true
    field :role, :string, default: "User"
    field :username, :string

    has_many :animals, Animal
    has_many :apis, Api

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

  def changeset_username(user, attrs) do
    user
    |> cast(attrs, [:username, :role])
    |> unique_constraint([:username])
    |> validate_required([:username, :role])
    |> validate_inclusion(:role, @acceptable_roles)
  end


  def changeset_password(user, attrs) do
    user
    |> cast(attrs, [:current_password, :password])
    |> validate_required([:current_password, :password])
    |> validate_confirmation(:password, message: "Passwords do not match")
    |> validate_change(:current_password, fn :current_password, plain_text_pwd ->
      case Pbkdf2.verify_pass(plain_text_pwd, user.hashed_password) do
        true -> []
        false -> [current_password: "Invalid password."]
      end
    end)
    |> put_password_hash()
  end

end
