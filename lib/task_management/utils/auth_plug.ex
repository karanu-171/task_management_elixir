defmodule TaskManagement.Auth.AuthPlug do
  import Plug.Conn
  alias TaskManagement.Auth.JWT
  alias TaskManagement.{Repo, Auth.User}

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        with {:ok, claims} <- JWT.verify_token(token),
             %User{} = user <- Repo.get(User, claims["sub"]) do 
          assign(conn, :current_user, user)
        else
          _ -> unauthorized(conn)
        end

      _ ->
        unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    res = TaskManagement.Response.error("Unauthorized", 401)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(res.statusCode, Jason.encode!(res))
    |> halt()
  end

end
