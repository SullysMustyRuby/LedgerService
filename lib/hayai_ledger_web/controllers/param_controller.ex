defmodule HayaiLedgerWeb.ParamController do
  use HayaiLedgerWeb, :controller

  import Ecto.Changeset, only: [{:put_change, 3}]

  alias HayaiLedger.Procedures
  alias HayaiLedger.Procedures.Param

  def new(conn, %{ "procedure_id" => procedure_id }) do
    changeset = Procedures.change_param(%Param{}) 
                |> put_change(:procedure_id, procedure_id)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{ "param" => param_params }) do
    with {:ok, organization_id} <- current_organization_id(conn),
      full_params <- Map.put(param_params, "organization_id", organization_id),
      {:ok, param} <- Procedures.create_param(full_params) 
    do
      conn
      |> put_flash(:info, "Param created successfully.")
      |> redirect(to: Routes.procedure_path(conn, :show, param.procedure_id))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    param = Procedures.get_param!(id)
    changeset = Procedures.change_param(param)
    render(conn, "edit.html", param: param, changeset: changeset)
  end

  def update(conn, %{"id" => id, "param" => param_params}) do
    param = Procedures.get_param!(id)

    case Procedures.update_param(param, param_params) do
      {:ok, param} ->
        conn
        |> put_flash(:info, "Param updated successfully.")
        |> redirect(to: Routes.procedure_path(conn, :show, param.procedure_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", param: param, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    param = Procedures.get_param!(id)
    {:ok, _param} = Procedures.delete_param(param)

    conn
    |> put_flash(:info, "Param deleted successfully.")
    |> redirect(to: Routes.procedure_path(conn, :show, param.procedure_id))
  end
end
