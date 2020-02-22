defmodule HayaiLedgerWeb.ProcedureController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Procedures
  alias HayaiLedger.Procedures.Procedure

  def index(conn, _params) do
    with {:ok, organization_id} <- current_organization_id(conn),
      procedures <- Procedures.list_procedures(organization_id)
    do
      render(conn, "index.html", procedures: procedures)
    end
  end

  def new(conn, _params) do
    changeset = Procedures.change_procedure(%Procedure{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{ "procedure" => procedure_params }) do
    with {:ok, organization_id} <- current_organization_id(conn),
      full_params <- Map.put(procedure_params, "organization_id", organization_id),
      {:ok, procedure} <- Procedures.create_procedure(full_params) 
    do
      conn
      |> put_flash(:info, "Procedure created successfully.")
      |> redirect(to: Routes.procedure_path(conn, :show, procedure))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{ "id" => id }) do
    procedure = Procedures.get_procedure!(id)
    render(conn, "show.html", %{ procedure: procedure })
  end

  def edit(conn, %{"id" => id}) do
    procedure = Procedures.get_procedure!(id)
    changeset = Procedures.change_procedure(procedure)
    render(conn, "edit.html", procedure: procedure, changeset: changeset)
  end

  def update(conn, %{"id" => id, "procedure" => procedure_params}) do
    procedure = Procedures.get_procedure!(id)

    case Procedures.update_procedure(procedure, procedure_params) do
      {:ok, procedure} ->
        conn
        |> put_flash(:info, "Procedure updated successfully.")
        |> redirect(to: Routes.procedure_path(conn, :show, procedure))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", procedure: procedure, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    procedure = Procedures.get_procedure!(id)
    {:ok, _procedure} = Procedures.delete_procedure(procedure)

    conn
    |> put_flash(:info, "Procedure deleted successfully.")
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end
end
