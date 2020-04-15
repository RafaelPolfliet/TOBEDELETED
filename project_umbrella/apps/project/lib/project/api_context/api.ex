defmodule Project.API.Api do
  use Ecto.Schema
  import Ecto.Changeset

  alias Project.UserContext.User

  schema "apis" do
    field :api_key, :string
    field :name, :string
    field :user_id, :id

    belongs_to :user, User
  end

  @doc false
  def changeset(api, attrs, user) do
    api
    |> cast(attrs, [:api_key, :name])
    |> validate_required([:api_key, :name])
    |> put_assoc(:user,user)
    |> validate_length(:api_key, :is 128)
  end
end
