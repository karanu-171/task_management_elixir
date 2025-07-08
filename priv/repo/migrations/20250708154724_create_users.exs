defmodule TaskManagement.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :username, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :first_login, :boolean, default: true

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
