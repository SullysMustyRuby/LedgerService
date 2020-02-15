defmodule Support.Authentication do
  use Phoenix.ConnTest
  use Plug.Test

  import Support.Fixtures.OrganizationFixtures, only: [{:user_fixture, 1}, {:membership_fixture, 1}, {:organization_fixture, 0}]
  import Support.Fixtures.AccountFixtures, only: [{:account_attrs, 0}, {:account_fixture, 1}]

  alias HayaiLedger.Accounts
  alias HayaiLedger.Organizations

  def login(user \\ nil)

  def login(nil) do
    user = user_fixture(%{})
    login(user)
  end

  def login(%HayaiLedger.Organizations.User{ id: id }) do
    organization = organization_fixture()
    membership_fixture(%{ "organization_id" => organization.id, "user_id" => id })
    init_test_session(build_conn(), %{ current_user_id: id, current_organization_id: organization.id })
  end

  def api_setup() do
    {:ok, account} = Accounts.create_account(account_attrs())
    {:ok, key} = Organizations.create_api_key(%{ kind: "full_api", organization_id: account.organization_id })
    %{
      auth_conn: build_auth_conn(key.data),
      account: account,
      key: key
    }
  end

  defp build_auth_conn(key) do
    build_conn() 
     |> put_req_header("accept", "application/json")
     |> put_req_header("x-api-key", key)
  end
end