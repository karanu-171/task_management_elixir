defmodule TaskManagement.Auth.PermissionPlug do
  import Plug.Conn
  alias TaskManagement.Auth.PermissionHelper
  alias TaskManagement.Response

  def init(required_permission), do: required_permission

  def call(%{assigns: %{current_user: user}} = conn, required_permission) do
    # Check if the user has a role assigned
    if is_nil(user.role_id) do
      res = Response.error("User does not have a role assigned", 403)

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(res.statusCode, Jason.encode!(res))
      |> halt()
    else
      permissions = PermissionHelper.get_permissions_for_role(user.role_id)

      if required_permission in permissions do
        conn
      else
        res = Response.error("Forbidden: Missing permission #{required_permission}", 403)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(res.statusCode, Jason.encode!(res))
        |> halt()
      end
    end
  end

  def call(conn, _required_permission) do
    res = Response.error("Unauthorized", 401)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(res.statusCode, Jason.encode!(res))
    |> halt()
  end
end
