defmodule TaskManagement.Repo do
  use Ecto.Repo,
    otp_app: :task_management,
    adapter: Ecto.Adapters.MyXQL
end
