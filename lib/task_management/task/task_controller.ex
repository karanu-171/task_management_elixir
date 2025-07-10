defmodule TaskManagement.TaskController do
  alias TaskManagement.{Repo, Task, Response}


  def list_tasks do
    tasks = Repo.all(Task)
    Response.ok(tasks)
  end

  def get_task(id) do
    case Repo.get(Task, id) do
      nil -> Response.error("Task not found", 404)
      task -> Response.ok(task)
    end
  end

  @spec create_task(any(), map()) :: %TaskManagement.Response{
          entity: any(),
          message: any(),
          statusCode: any()
        }
  def create_task(conn, params) do
    current_user = conn.assigns.current_user
    params = Map.put(params, "user_id", current_user.id)

    %Task{}
    |> Task.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, task} -> Response.created(task)
      {:error, changeset} -> Response.error("Validation failed: #{inspect changeset.errors}")
    end
  end

  def update_task(id, params) do
    case Repo.get(Task, id) do
      nil -> Response.error("Task not found", 404)
      task ->
        task
        |> Task.changeset(params)
        |> Repo.update()
        |> case do
          {:ok, updated} -> Response.ok(updated, "Task updated")
          {:error, changeset} -> Response.error("Update failed: #{inspect changeset.errors}")
        end
    end
  end

  def delete_task(id) do
    case Repo.get(Task, id) do
      nil -> Response.error("Task not found", 404)
      task ->
        Repo.delete(task)
        Response.ok(nil, "Task deleted")
    end
  end
end
