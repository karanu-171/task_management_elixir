defmodule TaskManagement.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :description, :due_date, :inserted_at, :updated_at]}
  schema "tasks" do
    field :title, :string
    field :description, :string
    field :due_date, :date

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :due_date])
    |> validate_required([:title, :description, :due_date])
  end
end
