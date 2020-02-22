defmodule HayaiLedgerWeb.Api.ProcedureView do
  use HayaiLedgerWeb, :api_view

  alias HayaiLedger.Accounts.Account
  alias HayaiLedgerWeb.Api.AccountView

  def render("show.json", %{ result: %Account{} = account }) do
  	render(AccountView, "show.json", %{ account: account })
  end
end