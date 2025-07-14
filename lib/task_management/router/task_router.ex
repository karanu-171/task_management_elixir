defmodule TaskManagement.Router.TaskRouter do
  use Plug.Router
  import Plug.Conn
  alias TaskManagement.TaskController
  alias TaskManagement.Auth.PermissionPlug

  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug TaskManagement.Auth.AuthPlug
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> PermissionPlug.call("GET_ALL_TASKS")
    |> case do
      %{halted: true} = conn -> conn
      conn ->
        res = TaskController.list_tasks()
        json(conn, res, res.statusCode)
    end
  end

  get "/:id" do
    conn
    |> PermissionPlug.call("GET_TASK_BY_ID")
    |> case do
      %{halted: true} = conn -> conn
      conn ->
        res = TaskController.get_task(String.to_integer(id))
        json(conn, res, res.statusCode)
    end
  end

  # ✅ POST /api/v1/task/add
  post "/add" do
    conn
    |> PermissionPlug.call("ADD_TASK")
    |> case do
      %{halted: true} = conn -> conn
      conn ->
        params = conn.body_params
        res = TaskController.create_task(conn, params)
        json(conn, res, res.statusCode)
    end
  end

  # ✅ PUT /api/v1/task/update/:id
  put "/update/:id" do
    conn
    |> PermissionPlug.call("UPDATE_TASK_BY_ID")
    |> case do
      %{halted: true} = conn -> conn
      conn ->
        params = conn.body_params
        res = TaskController.update_task(String.to_integer(id), params)
        json(conn, res, res.statusCode)
    end
  end

  # ✅ DELETE /api/v1/task/delete/:id
  delete "/delete/:id" do
    conn
    |> PermissionPlug.call("DELETE_TASK_BY_ID")
    |> case do
      %{halted: true} = conn -> conn
      conn ->
        res = TaskController.delete_task(String.to_integer(id))
        json(conn, res, res.statusCode)
    end
  end

  # Fallback route
  match _ do
    case conn.method do
      "GET" -> send_resp(conn, 405, "Method Not Allowed for this route")
      "POST" -> send_resp(conn, 405, "Method Not Allowed for this route")
      "PUT" -> send_resp(conn, 405, "Method Not Allowed for this route")
      "DELETE" -> send_resp(conn, 405, "Method Not Allowed for this route")
      _ -> send_resp(conn, 404, "Task route not found")
    end
  end

  defp json(conn, res, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(res))
  end
end
