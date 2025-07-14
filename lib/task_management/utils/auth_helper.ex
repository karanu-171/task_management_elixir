defmodule TaskManagement.Auth.PermissionHelper do
  import Ecto.Query
  alias TaskManagement.{Repo, RolePermission, Permission}

  def get_permissions_for_role(nil), do: []

  def get_permissions_for_role(role_id) do
    query =
      from rp in RolePermission,
        join: p in Permission, on: p.id == rp.permission_id,
        where: rp.role_id == ^role_id,
        select: p.name

    Repo.all(query)
  end
end
