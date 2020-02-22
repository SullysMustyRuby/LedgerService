defmodule HayaiLedgerWeb.InputController do
  use HayaiLedgerWeb, :controller

  import Ecto.Changeset, only: [{:put_change, 3}]

  alias HayaiLedger.Procedures
  alias HayaiLedger.Procedures.Input

  def new(conn, %{ "procedure_id" => procedure_id }) do
    changeset = Procedures.change_input(%Input{}) 
                |> put_change(:procedure_id, procedure_id)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{ "input" => input_params }) do
    with {:ok, organization_id} <- current_organization_id(conn),
      full_params <- Map.put(input_params, "organization_id", organization_id),
      {:ok, input} <- Procedures.create_input(full_params) 
    do
      conn
      |> put_flash(:info, "Input created successfully.")
      |> redirect(to: Routes.procedure_path(conn, :show, input.procedure_id))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    input = Procedures.get_input!(id)
    changeset = Procedures.change_input(input)
    render(conn, "edit.html", input: input, changeset: changeset)
  end

  def update(conn, %{"id" => id, "input" => input_params}) do
    input = Procedures.get_input!(id)

    case Procedures.update_input(input, input_params) do
      {:ok, input} ->
        conn
        |> put_flash(:info, "Input updated successfully.")
        |> redirect(to: Routes.procedure_path(conn, :show, input.procedure_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", input: input, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    input = Procedures.get_input!(id)
    {:ok, _input} = Procedures.delete_input(input)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.procedure_path(conn, :show, input.procedure_id))
  end
end
