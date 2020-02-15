defmodule HayaiLedgerWeb.AccountController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.Account
  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.FallbackController

  def index(conn, _params) do
    with {:ok, organization_id} <- current_organization_id(conn),
      accounts <- Accounts.list_accounts(organization_id)
    do
      render(conn, "index.html", accounts: accounts)
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_account(%Account{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{ "account" => account_params }) do
    with {:ok, organization_id} <- current_organization_id(conn),
      {:ok, account} <- Accounts.create_account(account_params, organization_id) 
    do
      conn
      |> put_flash(:info, "Account created successfully.")
      |> redirect(to: Routes.account_path(conn, :show, account))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{ "id" => id }) do
    account = Accounts.get_account!(id)
    render(conn, "show.html", %{ account: account })
  end

  def edit(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    changeset = Accounts.change_account(account)
    render(conn, "edit.html", account: account, changeset: changeset)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    case Accounts.update_account(account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: Routes.account_path(conn, :show, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
    end
  end
end
