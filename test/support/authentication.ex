defmodule Support.Authentication do
  use Phoenix.ConnTest
  use Plug.Test
  import Support.Fixtures.OrganizationFixtures, only: [{:user_fixture, 1}]

  def login(user \\ nil)

  def login(nil) do
    user = user_fixture(%{})
    login(user)
  end

  def login(%HayaiLedger.Organizations.User{ id: id }) do
    init_test_session(build_conn(), %{ current_user_id: id })
  end
end