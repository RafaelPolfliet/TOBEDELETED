defmodule Project.APITest do
  use Project.DataCase

  alias Project.API

  describe "apis" do
    alias Project.API.Api

    @valid_attrs %{api_key: "some api_key", name: "some name"}
    @update_attrs %{api_key: "some updated api_key", name: "some updated name"}
    @invalid_attrs %{api_key: nil, name: nil}

    def api_fixture(attrs \\ %{}) do
      {:ok, api} =
        attrs
        |> Enum.into(@valid_attrs)
        |> API.create_api()

      api
    end

    test "list_apis/0 returns all apis" do
      api = api_fixture()
      assert API.list_apis() == [api]
    end

    test "get_api!/1 returns the api with given id" do
      api = api_fixture()
      assert API.get_api!(api.id) == api
    end

    test "create_api/1 with valid data creates a api" do
      assert {:ok, %Api{} = api} = API.create_api(@valid_attrs)
      assert api.api_key == "some api_key"
      assert api.name == "some name"
    end

    test "create_api/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = API.create_api(@invalid_attrs)
    end

    test "update_api/2 with valid data updates the api" do
      api = api_fixture()
      assert {:ok, %Api{} = api} = API.update_api(api, @update_attrs)
      assert api.api_key == "some updated api_key"
      assert api.name == "some updated name"
    end

    test "update_api/2 with invalid data returns error changeset" do
      api = api_fixture()
      assert {:error, %Ecto.Changeset{}} = API.update_api(api, @invalid_attrs)
      assert api == API.get_api!(api.id)
    end

    test "delete_api/1 deletes the api" do
      api = api_fixture()
      assert {:ok, %Api{}} = API.delete_api(api)
      assert_raise Ecto.NoResultsError, fn -> API.get_api!(api.id) end
    end

    test "change_api/1 returns a api changeset" do
      api = api_fixture()
      assert %Ecto.Changeset{} = API.change_api(api)
    end
  end
end
