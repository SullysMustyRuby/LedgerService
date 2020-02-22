defmodule HayaiLedgerWeb.DashboardController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Organizations
	alias HayaiLedger.Organizations.User

  def index(conn, _params) do
  	with {:ok, user_id} <- current_user_id(conn),
  		memberships <- Organizations.list_memberships_for_user(user_id),
      organizations <- Enum.map(memberships, fn(membership) -> membership.organization end)
  	do
	  	render(conn, "index.html", %{ organizations: organizations })
  	end
  end
end
