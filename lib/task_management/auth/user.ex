defmodule TaskManagement.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :firstname, :lastname, :username, :email, :first_login]}
  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :username, :string
    field :email, :string
    field :password, :string
    field :first_login, :boolean, default: true

    belongs_to :role, TaskManagement.Role

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :username, :email, :password, :first_login, :role_id])
    |> validate_required([:firstname, :lastname, :username, :email, :password, :role_id])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
