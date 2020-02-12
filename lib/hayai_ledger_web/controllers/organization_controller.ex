defmodule HayaiLedgerWeb.OrganizationController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Organizations
  alias HayaiLedger.Organizations.Organization

  def index(conn, params) do
    user = current_user(conn)
    organizations = Organizations.list_organizations(user)
    render(conn, "index.html", organizations: organizations)
  end

  def new(conn, _params) do
    changeset = Organizations.change_organization(%Organization{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"organization" => organization_params}) do
    case Organizations.create_organization(organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: Routes.organization_path(conn, :show, organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)
    render(conn, "show.html", organization: organization)
  end

  def edit(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)
    changeset = Organizations.change_organization(organization)
    render(conn, "edit.html", organization: organization, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Organizations.get_organization!(id)

    case Organizations.update_organization(organization, organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: Routes.organization_path(conn, :show, organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", organization: organization, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)
    {:ok, _organization} = Organizations.delete_organization(organization)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: Routes.organization_path(conn, :index))
  end
end
