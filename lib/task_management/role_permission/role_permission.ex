defmodule TaskManagement.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :role_id, :permission_id]}
  schema "role_permissions" do
    belongs_to :role, TaskManagement.Role
    belongs_to :permission, TaskManagement.Permission

    timestamps()
  end

  def changeset(role_permission, attrs) do
    role_permission
    |> cast(attrs, [:role_id, :permission_id])
    |> validate_required([:role_id, :permission_id])
    |> unique_constraint(:role_id_permission_id, name: :role_permissions_role_id_permission_id_index)
    |> foreign_key_constraint(:role_id, name: :role_permissions_role_id_fkey)
    |> foreign_key_constraint(:permission_id, name: :role_permissions_permission_id_fkey)
  end
end
