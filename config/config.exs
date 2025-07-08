import Config

config :task_management, TaskManagement.Repo,
  username: "root",
  password: "",
  hostname: "localhost",
  database: "task_management",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :task_management, ecto_repos: [TaskManagement.Repo]
