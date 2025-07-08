defmodule TaskManagement.Application do
  use Application
  require Logger


  def start(_type, _args) do
  
    children = [
      {Plug.Cowboy, scheme: :http, plug: TaskManagement.Router, options: [port: 4000]},
      TaskManagement.Repo
    ]


    Logger.info("Server running on http://localhost:4000")
    opts = [strategy: :one_for_one, name: TaskManagement.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
