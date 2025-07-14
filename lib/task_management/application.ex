defmodule TaskManagement.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      TaskManagement.Repo,
      {Plug.Cowboy, scheme: :http, plug: TaskManagement.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: TaskManagement.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    # Spawn a task to check DB connectivity
    Task.start(fn ->
      
      :timer.sleep(100)

      try do
        TaskManagement.Repo.query!("SELECT 1")
        Logger.info("✅ Successfully connected to the database")
      rescue
        e ->
          Logger.error("❌ Failed to connect to the database: #{inspect(e)}")
      end
    end)

    Logger.info("🚀 Server running on http://localhost:4000")
    {:ok, pid}
  end
end
