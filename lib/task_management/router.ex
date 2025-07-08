defmodule TaskManagement.Router do
  use Plug.Router
  import Plug.Conn
  alias TaskManagement.TaskController

  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Task Management API")
  end

  get "/tasks" do
    res = TaskController.list_tasks()
    json(conn, res, res.statusCode)
  end

  get "/tasks/:id" do
    res = TaskController.get_task(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  post "/tasks/add" do
    params = conn.body_params
    res = TaskController.create_task(params)
    json(conn, res, res.statusCode)
  end


  put "/tasks/update/:id" do
    params = conn.body_params
    res = TaskController.update_task(String.to_integer(id), params)
    json(conn, res, res.statusCode)
  end


  delete "/tasks/delete/:id" do
    res = TaskController.delete_task(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp json(conn, res, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(res))
  end
end
