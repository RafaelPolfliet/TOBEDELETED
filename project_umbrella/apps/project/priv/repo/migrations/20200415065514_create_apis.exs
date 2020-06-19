defmodule Project.Repo.Migrations.CreateApis do
  use Ecto.Migration

  def change do
    create table(:apis) do
      add :api_key, :string, null: false
      add :name, :string, null: false
      add :writeable, :boolean, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

    end

    create index(:apis, [:user_id])
  end
end
