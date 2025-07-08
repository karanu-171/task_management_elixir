defmodule TaskManagement.Router do
  use Plug.Router
  import Plug.Conn

  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Task Management API Root")
  end

  forward "/api/v1/tasks", to: TaskManagement.Router.TaskRouter
  forward "/api/v1/auth", to: TaskManagement.Router.AuthRouter

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
