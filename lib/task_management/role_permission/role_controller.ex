defmodule TaskManagement.RoleController do
  import Ecto.Query
  alias TaskManagement.{Repo, Role, Permission, RolePermission, Response}

  ### ROLES

  def list_roles do
    roles = Repo.all(Role)
    Response.ok(roles)
  end

  def get_role(id) do
    case Repo.get(Role, id) do
      nil -> Response.error("Role not found", 404)
      role -> Response.ok(role)
    end
  end

  def create_role(%{"name" => name} = attrs) do
    case Repo.get_by(Role, name: name) do
      nil ->
        %Role{}
        |> Role.changeset(attrs)
        |> Repo.insert()
        |> case do
          {:ok, role} -> Response.created(role, "Role created successfully")
          {:error, changeset} -> Response.error("Failed to create role: #{inspect(changeset.errors)}")
        end

      _existing ->
        Response.error("Role with name '#{name}' already exists", 409)
    end
  end

  def update_role(id, params) do
    case Repo.get(Role, id) do
      nil -> Response.error("Role not found", 404)
      role ->
        role
        |> Role.changeset(params)
        |> Repo.update()
        |> case do
          {:ok, updated_role} -> Response.ok(updated_role, "Role updated successfully")
          {:error, changeset} -> Response.error("Update failed: #{inspect(changeset.errors)}")
        end
    end
  end

  def delete_role(id) do
    case Repo.get(Role, id) do
      nil -> {:error, "Role not found"}
      role -> Repo.delete(role)
    end
  end

  ### PERMISSIONS

  def list_permissions do
    permission = Repo.all(Permission)
    Response.ok(permission)
  end

  def get_permission(id) do
    case Repo.get(Permission, id) do
      nil -> Response.error("Permission not found", 404)
      permission -> Response.ok(permission)
    end
  end


  def create_permission(%{"name" => name} = attrs) do
    case Repo.get_by(Permission, name: name) do
      nil ->
        %Permission{}
        |> Permission.changeset(attrs)
        |> Repo.insert()
        |> case do
            {:ok, permission} -> Response.created(permission, "Permission created successfully")
            {:error, changeset} -> Response.error("Failed to create permission: #{inspect(changeset.errors)}")
        end
      _existing ->
        Response.error("Permission with name '#{name}' already exists", 409)
    end
  end

  def update_permission(id, params) do
    case Repo.get(Permission, id) do
      nil -> Response.error("Permission not found", 404)
      permission ->
         permission
         |> Permission.changeset(params)
         |> Repo.update()
         |> case do
          {:ok, updated_permission} -> Response.ok(updated_permission, "Permission updated successfully")
          {:error, changeset} -> Response.error("Update failed: #{inspect(changeset.errors)}")
        end
    end
  end

  def delete_permission(id) do
    case Repo.get(Permission, id) do
      nil ->
        Response.error("Permission not found", 404)

      permission ->
        case Repo.delete(permission) do
          {:ok, _deleted} ->
            Response.ok(nil, "Permission deleted successfully")

          {:error, changeset} ->
            Response.error("Failed to delete permission: #{inspect(changeset.errors)}")
        end
    end
  end

  ### ROLE-PERMISSIONS
  def list_role_permissions do
    permissions = Repo.all(RolePermission)
    Response.ok(permissions)
  end

  # Get one role_permission by ID
  def get_role_permission(id) do
    case Repo.get(RolePermission, id) do
      nil -> Response.error("RolePermission not found", 404)
      role_permission -> Response.ok(role_permission)
    end
  end

  def assign_permission_to_role(%{"role_id" => role_id, "permission_id" => permission_id}) do
    %RolePermission{}
    |> RolePermission.changeset(%{role_id: role_id, permission_id: permission_id})
    |> Repo.insert()
    |> case do
      {:ok, mapping} ->
        TaskManagement.Response.created(mapping, "Permission assigned to role successfully")

      {:error, changeset} ->
        TaskManagement.Response.error("Failed to assign permission: #{inspect(changeset.errors)}")
    end
  end

  def update_role_permission(id, params) do
    case Repo.get(RolePermission, id) do
      nil ->
        Response.error("RolePermission not found", 404)

      role_permission ->
        role_permission
        |> RolePermission.changeset(params)
        |> Repo.update()
        |> case do
          {:ok, updated} -> Response.ok(updated, "RolePermission updated successfully")
          {:error, changeset} -> Response.error("Update failed: #{inspect(changeset.errors)}")
        end
    end
  end

  def revoke_permission(role_id, permission_id) do
    query =
      from rp in RolePermission,
        where: rp.role_id == ^role_id and rp.permission_id == ^permission_id

    case Repo.one(query) do
      nil ->
        TaskManagement.Response.error("Mapping not found", 404)

      mapping ->
        case Repo.delete(mapping) do
          {:ok, _} -> TaskManagement.Response.ok(nil, "Permission revoked")
          {:error, changeset} -> TaskManagement.Response.error("Failed to revoke: #{inspect(changeset.errors)}")
        end
    end
  end

end
