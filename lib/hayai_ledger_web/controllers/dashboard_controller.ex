defmodule HayaiLedgerWeb.DashboardController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Organizations
	alias HayaiLedger.Organizations.User

  def index(conn, _params) do
  	with {:ok, user_id} <- current_user_id(conn),
  		organizations when is_list(organizations) <- Organizations.get_user_organizations(user_id) 
  	do
	  	render(conn, "index.html", %{ organizations: organizations })
  	end
  end
end
