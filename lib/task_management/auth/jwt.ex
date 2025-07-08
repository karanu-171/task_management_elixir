defmodule TaskManagement.Auth.JWT do
  @secret "supersecret"  

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
end
