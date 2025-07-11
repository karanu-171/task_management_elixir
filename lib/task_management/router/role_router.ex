defmodule TaskManagement.Router.RoleRouter do
  use Plug.Router
  import Plug.Conn
  alias TaskManagement.RoleController

  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug TaskManagement.Auth.AuthPlug
  plug :match
  plug :dispatch

  ### ROLE ROUTES

  get "/" do
    res = RoleController.list_roles()
    json(conn, res, res.statusCode)
  end

  get "/:id" do
    res = RoleController.get_role(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  post "/add" do
    params = conn.body_params
    res = RoleController.create_role(params)
    json(conn, res, res.statusCode)
  end

  put "/update/:id" do
    params = conn.body_params
    res =  RoleController.update_role(String.to_integer(id), params)
    json(conn, res, res.statusCode)
  end

  delete "/delete/:id" do
    res = RoleController.delete_role(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  ### PERMISSION ROUTES

  get "/permission/all" do
    res = RoleController.list_permissions()
    json(conn, res, res.statusCode)
  end

  get "/permission/:id" do
    res = RoleController.get_permission(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  post "/permission/add" do
    params = conn.body_params
    res = RoleController.create_permission(params)
    json(conn, res, res.statusCode)
  end

  put "/permission/update/:id" do
    params = conn.body_params
    res = RoleController.update_permission(String.to_integer(id), params)
    json(conn, res, res.statusCode)
  end

  delete "/permission/delete/:id" do
    res = RoleController.delete_permission(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  ### ROLE-PERMISSION MAPPING
  get "/role-permissions/all" do
    res = RoleController.list_role_permissions()
    json(conn, res, res.statusCode)
  end

   get "/role-permissions/:id" do
    res = RoleController.get_role_permission(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  post "/role-permissions/assign" do
    params = conn.body_params
    res = RoleController.assign_permission_to_role(params)
    json(conn, res, res.statusCode)
  end

  put "/role-permissions/update/:id" do
    params = Map.put(conn.body_params, "id", id)
    res = RoleController.update_role_permission(String.to_integer(id), params)
    json(conn, res, res.statusCode)
  end
  delete "/role-permissions/revoke" do
    %{"role_id" => role_id, "permission_id" => permission_id} = conn.body_params

    res = RoleController.revoke_permission(role_id, permission_id)
    json(conn, res, res.statusCode)
  end

  ### DEFAULT
  match _ do
    response = TaskManagement.Response.error("Method Not Allowed or Route Not Found", 405)
    json(conn, response, response.statusCode)
  end

  defp json(conn, res, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(res))
  end
end
