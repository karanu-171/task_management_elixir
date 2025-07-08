defmodule TaskManagement.Router.AuthRouter do
  use Plug.Router
  import Plug.Conn
  alias TaskManagement.Auth.UserController

  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :match
  plug :dispatch

  post "/register" do
    params = conn.body_params
    res = UserController.register_user(params)
    json(conn, res, res.statusCode)
  end

  post "/login" do
    params = conn.body_params
    res = UserController.login_user(params)
    json(conn, res, res.statusCode)
  end

  put "/password" do
    params = conn.body_params
    res = UserController.update_password(params)
    json(conn, res, res.statusCode)
  end

  # Update user profile
  put "/update/:id" do
    params = conn.body_params
    res = UserController.update_user(String.to_integer(id), params)
    json(conn, res, res.statusCode)
  end

  # Get user by ID
  get "/users/:id" do
    res = UserController.get_user(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  # Get all users
  get "/users" do
    res = UserController.get_all_users()
    json(conn, res, res.statusCode)
  end

  # Delete user by ID
  delete "/delete/:id" do
    res = UserController.delete_user(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  # We'll add login here later
  match _ do
    send_resp(conn, 404, "Auth route not found")
  end

  defp json(conn, res, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(res))
  end
end
