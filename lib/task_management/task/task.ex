defmodule TaskManagement.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :description, :due_date, :user_id, :inserted_at, :updated_at]}
  schema "tasks" do
    field :title, :string
    field :description, :string
    field :due_date, :date

    belongs_to :user, TaskManagement.Auth.User

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :due_date, :user_id])
    |> validate_required([:title, :description, :due_date, :user_id])
  end
end
