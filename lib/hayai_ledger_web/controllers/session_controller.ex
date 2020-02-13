defmodule HayaiLedgerWeb.SessionController do
  use HayaiLedgerWeb, :controller

  import HayaiLedger.Organizations.Encryption, only: [{:validate_password, 2}]

  alias HayaiLedger.Organizations

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    user = Organizations.get_by_email(auth_params["email"])
    case validate_password(user, auth_params["password"]) do
    {:ok, user} ->
      conn
      |> put_session(:current_user_id, user.id)
      |> put_flash(:info, "Signed in successfully.")
      |> redirect(to: Routes.dashboard_path(conn, :index))
    {:error, _} ->
      conn
      |> put_flash(:error, "There was a problem with your username/password")
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.public_path(conn, :index))
  end
end