defmodule TaskManagement.Auth.UserController do
  alias TaskManagement.{Repo, Response}
  alias TaskManagement.Auth.User

  # Register user with auto-generated password
  def register_user(params) do
    password = generate_password()
    full_params = Map.put(params, "password", password)

    %User{}
    |> User.changeset(full_params)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        IO.puts("Generated password for user #{user.username}: #{password}")
        Response.created(user, "User created successfully")

      {:error, changeset} ->
        Response.error("Failed to create user: #{inspect(changeset.errors)}")
    end
  end

  # Login user and return token
  def login_user(%{"username" => username, "password" => password}) do
    case Repo.get_by(User, username: username) do
      nil -> Response.error("User not found", 404)
      user when user.password != password -> Response.error("Invalid password", 401)
      user ->
        token = TaskManagement.Auth.JWT.generate_token(user.id)
        Response.ok(%{token: token, user: user}, "Login successful")
    end
  end

  # Update user password and set first_login to false
  def update_password(%{"username" => username, "new_password" => new_pass}) do
    case Repo.get_by(User, username: username) do
      nil -> Response.error("User not found", 404)
      user ->
        user
        |> Ecto.Changeset.change(%{password: new_pass, first_login: false})
        |> Repo.update()
        |> case do
          {:ok, updated_user} -> Response.ok(updated_user, "Password updated successfully")
          {:error, changeset} -> Response.error("Update failed: #{inspect(changeset.errors)}")
        end
    end
  end

  # Update user info (not password)
  def update_user(id, params) do
    case Repo.get(User, id) do
      nil -> Response.error("User not found", 404)
      user ->
        user
        |> User.changeset(params)
        |> Repo.update()
        |> case do
          {:ok, updated_user} -> Response.ok(updated_user, "User updated successfully")
          {:error, changeset} -> Response.error("Update failed: #{inspect(changeset.errors)}")
        end
    end
  end

  # Fetch all users
  def get_all_users do
    users = Repo.all(User)
    Response.ok(users)
  end

  # Fetch user by ID
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> Response.error("User not found", 404)
      user -> Response.ok(user)
    end
  end

  # Delete user
  def delete_user(id) do
    case Repo.get(User, id) do
      nil -> Response.error("User not found", 404)
      user ->
        case Repo.delete(user) do
          {:ok, _} -> Response.ok(nil, "User deleted successfully")
          {:error, _} -> Response.error("Failed to delete user")
        end
    end
  end

  defp generate_password do
    :crypto.strong_rand_bytes(6)
    |> Base.encode32(padding: false)
    |> binary_part(0, 8)
  end
end
