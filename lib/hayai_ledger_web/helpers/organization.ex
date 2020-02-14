defmodule HayaiLedgerWeb.Helpers.Organization do

  def current_organization(conn) do
    conn.assigns[:current_organization]
  end

  def current_organization_id(conn) do
    with organization_id when is_integer(organization_id) <- Plug.Conn.get_session(conn, "current_organization_id") do
      {:ok, organization_id}
    else
      _ -> {:error, "no current organization"}
    end
  end

  def organization_id(conn) do
    with organization_id when is_integer(organization_id) <- Plug.Conn.get_session(conn, "organization_id") do
      {:ok, organization_id}
    else
      _ -> {:error, "no current organization"}
    end
  end
end