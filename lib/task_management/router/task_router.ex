defmodule TaskManagement.Router.TaskRouter do
  use Plug.Router
  import Plug.Conn
  alias TaskManagement.TaskController

  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug TaskManagement.Auth.AuthPlug
  plug :match
  plug :dispatch

  get "/" do
    res = TaskController.list_tasks()
    json(conn, res, res.statusCode)
  end

  get "/:id" do
    res = TaskController.get_task(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  post "/add" do
    params = conn.body_params
    res = TaskController.create_task(conn, params)
    json(conn, res, res.statusCode)
  end

  put "/update/:id" do
    params = conn.body_params
    res = TaskController.update_task(String.to_integer(id), params)
    json(conn, res, res.statusCode)
  end

  delete "/delete/:id" do
    res = TaskController.delete_task(String.to_integer(id))
    json(conn, res, res.statusCode)
  end

  match _ do
    send_resp(conn, 404, "Task route not found")
  end

  defp json(conn, res, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(res))
  end
end
