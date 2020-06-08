defmodule HayaiLedgerWeb.Plugs.Organization do
  
  import Plug.Conn

  alias HayaiLedger.Organizations

  def init(opts), do: opts

  def call(conn, _opts) do
    case Plug.Conn.get_session(conn, :current_organization_id) do
      nil -> conn
      current_organization_id -> assign_organization(conn, current_organization_id)
    end
  end

  defp assign_organization(conn, current_organization_id) do
    organization = Organizations.get_organization!(current_organization_id)
    conn
      |> assign(:current_organization, organization)
  end
end
