defmodule HayaiLedgerWeb.Helpers.Auth do
  alias HayaiLedger.Organizations.{Encryption, User}

  def login(params, repo) do
    user = repo.get_by(User, username: String.downcase(params["username"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    if user do
      {:ok, authenticated_user} = Encryption.validate_password(user, password)
      authenticated_user.username == user.username
    else
      nil
    end
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def signed_in?(conn) do
    case current_user(conn) do
      %User{} -> true
      _ -> false
    end
  end

  def signed_in?(%Plug.Conn{ assigns: %{ current_user: %User{ id: id} } }, user_id), do: user_id == id

  def signed_in?(_conn, _user_id), do: false
end