defmodule Project.APIContext do
  @moduledoc """
  The API context.
  """

  import Ecto.Query, warn: false
  alias Project.Repo

  alias Project.APIContext.Api
  alias Project.UserContext.User

  @doc """
  Returns the list of apis.

  ## Examples

      iex> list_apis()
      [%Api{}, ...]

  """

  def load_users_apis(%User{} = u) do
    u
    |> Repo.preload([:apis])
  end


  def list_apis do
    Repo.all(Api)
  end

  @doc """
  Gets a single api.

  Raises `Ecto.NoResultsError` if the Api does not exist.

  ## Examples

      iex> get_api!(123)
      %Api{}

      iex> get_api!(456)
      ** (Ecto.NoResultsError)

  """
  def get_api!(id), do: Repo.get!(Api, id)

  def get_api_for_user(id,%User{} = user) do
     case Repo.get(Api, id) do
      nil ->  {:error, "Permission denied"}
      api ->
            if (api != nil && api.user_id === user.id) do
            {:ok, api}
           else
            {:error, "Permission denied"}
          end
      end
  end

  @doc """
  Creates a api.

  ## Examples

      iex> create_api(%{field: value})
      {:ok, %Api{}}

      iex> create_api(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_api(attrs \\ %{}, %User{} = user) do

    token = Phoenix.Token.sign(ProjectWeb.Endpoint,"userAPIkey", user.id)
    
    %Api{}
    |> Ecto.Changeset.change(%{api_key: token})
    |> Api.create_changeset(attrs,user)
    |> Repo.insert()
  end

  @doc """
  Updates a api.

  ## Examples

      iex> update_api(api, %{field: new_value})
      {:ok, %Api{}}

      iex> update_api(api, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_api(%Api{} = api, attrs) do
    api
    |> Api.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a api.

  ## Examples

      iex> delete_api(api)
      {:ok, %Api{}}

      iex> delete_api(api)
      {:error, %Ecto.Changeset{}}

  """
  def delete_api(%Api{} = api) do
    Repo.delete(api)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking api changes.

  ## Examples

      iex> change_api(api)
      %Ecto.Changeset{source: %Api{}}

  """
  def change_api(%Api{} = api) do
    Api.changeset(api, %{})
  end
end
