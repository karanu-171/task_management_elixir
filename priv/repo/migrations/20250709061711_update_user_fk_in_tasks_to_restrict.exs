defmodule TaskManagement.Repo.Migrations.UpdateUserFkInTasksToRestrict do
  use Ecto.Migration

  def change do
    # Drop the existing foreign key constraint
    execute "ALTER TABLE tasks DROP FOREIGN KEY tasks_user_id_fkey"

    # Re-add the foreign key with ON DELETE RESTRICT
    alter table(:tasks) do
      modify :user_id, references(:users, on_delete: :restrict), null: false
    end
  end
end
