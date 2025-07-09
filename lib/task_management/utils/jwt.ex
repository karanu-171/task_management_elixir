defmodule TaskManagement.Auth.JWT do
  @secret "834c41e14e9c849e4cf9a99e3a06f050"

  def generate_token(user_id) do
    claims = %{
      "sub" => user_id,
      "exp" => :os.system_time(:seconds) + 7 * 24 * 60 * 60  # 1 week
    }

    key = JOSE.JWK.from_oct(@secret)

    JOSE.JWT.sign(key, %{"alg" => "HS256"}, claims)
    |> JOSE.JWS.compact()
    |> elem(1)
  end

  def verify_token(token) do
    key = JOSE.JWK.from_oct(@secret)

    case JOSE.JWT.verify_strict(key, ["HS256"], token) do
      {true, %JOSE.JWT{fields: claims}, _jws} ->
        now = :os.system_time(:seconds)

        if claims["exp"] && claims["exp"] > now do
          {:ok, claims}
        else
          {:error, :token_expired}
        end

      _ ->
        {:error, :invalid_token}
    end
  end
end
