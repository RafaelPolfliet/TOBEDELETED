defmodule Project.APIContext.Api do
  use Ecto.Schema
  import Ecto.Changeset

  alias Project.UserContext.User

  schema "apis" do
    field :api_key, :string
    field :name, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(api, attrs) do
    api
    |> cast(attrs, [:api_key, :name])
    |> validate_required([:api_key, :name])

  end

  def create_changeset(api, attrs, user) do
    api
    |> cast(attrs, [:api_key, :name])
    |> validate_required([:api_key, :name])
    |> put_assoc(:user,user)

  end

end
