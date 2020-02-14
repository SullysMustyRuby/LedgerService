defmodule HayaiLedgerWeb.ApiKeyController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Organizations
  alias HayaiLedger.Organizations.{ApiKey, Organization}

  # GET
  def index(conn, _params) do
    with %Organization{ id: organization_id } <- conn.assigns[:current_organization] do
    	api_keys = Organizations.list_api_keys(organization_id)
      render(conn, "index.html", %{ api_keys: api_keys })
    end
  end

  # GET
  def show(conn, %{ "id" => id }) do
  	with %ApiKey{} = api_key <- Organizations.get_api_key(id) do
	  	render(conn, "show.html", %{ api_key: api_key })
	  end
  end
end
