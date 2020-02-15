defmodule Support.Fixtures.OrganizationFixtures do

	alias HayaiLedger.Organizations

  def api_key_attrs() do
    %{
      "kind" => "full_api",
      "organization_id" => organization_fixture().id
    }
  end

  def api_key_fixture(attrs \\ %{}) do
    {:ok, api_key} =
      attrs
      |> Enum.into(api_key_attrs())
      |> Organizations.create_api_key()

    api_key
  end

	def membership_attrs() do
    %{
      "organization_id" => organization_fixture().id,
      "user_id" => user_fixture().id
    }
	end

  def membership_fixture(attrs \\ %{}) do
    {:ok, membership} =
      attrs
      |> Enum.into(membership_attrs())
      |> Organizations.create_membership()

    membership
  end

  def organization_attrs() do
  	%{
  		"description" => "The best ledger system perid!", 
  		"name" => "HaiyaiLedger"
  	}
  end

  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(organization_attrs())
      |> Organizations.create_organization()

    organization
  end

  def user_attrs() do
    email = :crypto.strong_rand_bytes(12) |> Base.url_encode64
  	%{ 
  		"email" => "#{email}@haiyailedger.com", 
  		"first_name" => "Shina", 
  		"last_name" => "Ringo", 
  		"password" => "SuperSexy", 
  		"password_confirmation" => "SuperSexy"
  	}
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(user_attrs())
      |> Organizations.create_user()

    user
  end

end