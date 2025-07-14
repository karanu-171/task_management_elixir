defmodule TaskManagement.Auth.UserController do
  alias TaskManagement.{Repo, Response}
  alias TaskManagement.Auth.{User, JWT}
  import Ecto.Changeset

  ## Register a user with an auto-generated password
  def register_user(params) do
    password = generate_password()
    full_params = Map.put(params, "password", password)

    %User{}
    |> User.changeset(full_params)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        user = preload_role(user)
        IO.puts("Generated password for user #{user.username}: #{password}")
        Response.created(user, "User created successfully")

      {:error, changeset} ->
        Response.error("Failed to create user: #{inspect(changeset.errors)}")
    end
  end

  ## Login user and return token
  def login_user(%{"username" => username, "password" => password}) do
    with %User{} = user <- Repo.get_by(User, username: username),
         true <- user.password == password do
      user = preload_role(user)
      token = JWT.generate_token(user.id)
      Response.ok(%{token: token, user: user}, "Login successful")
    else
      nil -> Response.error("User not found", 404)
      false -> Response.error("Invalid password", 401)
    end
  end

  ## Update password and mark first login complete
  def update_password(%{"username" => username, "new_password" => new_pass}) do
    with %User{} = user <- Repo.get_by(User, username: username),
         {:ok, updated_user} <- change(user, %{password: new_pass, first_login: false}) |> Repo.update() do
      Response.ok(preload_role(updated_user), "Password updated successfully")
    else
      nil -> Response.error("User not found", 404)
      {:error, changeset} -> Response.error("Update failed: #{inspect(changeset.errors)}")
    end
  end

  ## Update user info
  def update_user(id, params) do
    with %User{} = user <- Repo.get(User, id),
         {:ok, updated_user} <- User.changeset(user, params) |> Repo.update() do
      Response.ok(preload_role(updated_user), "User updated successfully")
    else
      nil -> Response.error("User not found", 404)
      {:error, changeset} -> Response.error("Update failed: #{inspect(changeset.errors)}")
    end
  end

  ## Get all users with roles
  def get_all_users do
    User
    |> Repo.all()
    |> Repo.preload(:role)
    |> Response.ok()
  end

  ## Get user by ID with role
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> Response.error("User not found", 404)
      user -> Response.ok(preload_role(user))
    end
  end

  ## Delete user, handle foreign key errors
  def delete_user(id) do
    case Repo.get(User, id) do
      nil -> Response.error("User not found", 404)
      user ->
        try do
          case Repo.delete(user) do
            {:ok, _} -> Response.ok(nil, "User deleted successfully")
            {:error, changeset} -> Response.error("Delete failed: #{inspect(changeset.errors)}")
          end
        rescue
          Ecto.ConstraintError ->
            Response.error("Cannot delete user: they have tasks assigned", 400)

          e ->
            Response.error("Unexpected error: #{Exception.message(e)}", 500)
        end
    end
  end

  ## Private Helpers

  defp preload_role(user), do: Repo.preload(user, :role)

  defp generate_password do
    :crypto.strong_rand_bytes(6)
    |> Base.encode32(padding: false)
    |> binary_part(0, 8)
  end
end
