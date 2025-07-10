defmodule TaskManagement.Router.AuthRouter do
  use Plug.Router
  import Plug.Conn
  alias TaskManagement.Auth.{UserController, AuthPlug}

  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :match

  plug :maybe_protect

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

  # Protected routes
  put "/password" do
    params = conn.body_params
    res = UserController.update_password(params)
    json(conn, res, res.statusCode)
  end

  put "/update/:id" do
    params = conn.body_params
    res = UserController.update_user(String.to_integer(id), params)
    json(conn, res, res.statusCode)
  end

  get "/users/:id" do
    res = UserController.get_user(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  get "/users" do
    res = UserController.get_all_users()
    json(conn, res, res.statusCode)
  end

  delete "/delete/:id" do
    res = UserController.delete_user(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  match _ do
    case conn.method do
      "GET" -> send_resp(conn, 405, "Method Not Allowed for this route")
      "POST" -> send_resp(conn, 405, "Method Not Allowed for this route")
      "PUT" -> send_resp(conn, 405, "Method Not Allowed for this route")
      "DELETE" -> send_resp(conn, 405, "Method Not Allowed for this route")
      _ -> send_resp(conn, 404, "Auth route not found")
    end
  end


  defp json(conn, res, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(res))
  end

  defp maybe_protect(conn, _) do
    case conn.request_path do
      "/api/v1/auth/register" -> conn
      "/api/v1/auth/login" -> conn
      _ -> AuthPlug.call(conn, [])
    end
  end
end
