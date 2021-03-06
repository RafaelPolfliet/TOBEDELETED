defmodule ProjectWeb.AnimalControllerTest do
  use ProjectWeb.ConnCase

  alias Project.AnimalContext

  @create_attrs %{date_of_birth: ~D[2010-04-17], name: "some name", type: "some type"}
  @update_attrs %{date_of_birth: ~D[2011-05-18], name: "some updated name", type: "some updated type"}
  @invalid_attrs %{date_of_birth: nil, name: nil, type: nil}

  def fixture(:animal) do
    {:ok, animal} = AnimalContext.create_animal(@create_attrs)
    animal
  end

  describe "index" do
    test "lists all animals", %{conn: conn} do
      conn = get(conn, Routes.animal_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Animals"
    end
  end

  describe "new animal" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.animal_path(conn, :new))
      assert html_response(conn, 200) =~ "New Animal"
    end
  end

  describe "create animal" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.animal_path(conn, :create), animal: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.animal_path(conn, :show, id)

      conn = get(conn, Routes.animal_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Animal"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.animal_path(conn, :create), animal: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Animal"
    end
  end

  describe "edit animal" do
    setup [:create_animal]

    test "renders form for editing chosen animal", %{conn: conn, animal: animal} do
      conn = get(conn, Routes.animal_path(conn, :edit, animal))
      assert html_response(conn, 200) =~ "Edit Animal"
    end
  end

  describe "update animal" do
    setup [:create_animal]

    test "redirects when data is valid", %{conn: conn, animal: animal} do
      conn = put(conn, Routes.animal_path(conn, :update, animal), animal: @update_attrs)
      assert redirected_to(conn) == Routes.animal_path(conn, :show, animal)

      conn = get(conn, Routes.animal_path(conn, :show, animal))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, animal: animal} do
      conn = put(conn, Routes.animal_path(conn, :update, animal), animal: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Animal"
    end
  end

  describe "delete animal" do
    setup [:create_animal]

    test "deletes chosen animal", %{conn: conn, animal: animal} do
      conn = delete(conn, Routes.animal_path(conn, :delete, animal))
      assert redirected_to(conn) == Routes.animal_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.animal_path(conn, :show, animal))
      end
    end
  end

  defp create_animal(_) do
    animal = fixture(:animal)
    {:ok, animal: animal}
  end
end
