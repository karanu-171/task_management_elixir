defmodule TaskManagement.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :due_date, :date, null: false

      timestamps()
    end
  end
end
