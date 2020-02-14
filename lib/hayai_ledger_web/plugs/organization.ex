defmodule HayaiLedgerWeb.Plugs.Organization do
  
  import Plug.Conn
  import Phoenix.Controller

  alias HayaiLedger.Organizations

  def init(opts), do: opts

  def call(conn, _opts) do
    if current_organization_id = Plug.Conn.get_session(conn, :current_organization_id) do
      organization = Organizations.get_organization!(current_organization_id)
      conn
        |> assign(:current_organization, organization)
    else
      conn
    end
  end
end
