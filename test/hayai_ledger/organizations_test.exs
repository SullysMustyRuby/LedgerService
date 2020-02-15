defmodule HayaiLedger.OrganizationsTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Organizations
  alias HayaiLedger.Organizations.{ApiKey, Organization, User}

  import Support.Fixtures.OrganizationFixtures

  describe "organizations" do
    @valid_org_attrs %{description: "some description", name: "some name"}
    @update_org_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_org_attrs %{description: nil, name: nil}

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Organizations.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} = Organizations.create_organization(@valid_org_attrs)
      assert organization.description == "some description"
      assert organization.name == "some name"
    end

    test "create_organization/2 with valid data creates a organization and a membership" do
      user = user_fixture()
      assert 0 == length(Organizations.list_memberships())
      assert {:ok, %Organization{} = organization} = Organizations.create_organization(@valid_org_attrs, user.id)
      assert organization.description == "some description"
      assert organization.name == "some name"
      assert 1 == length(Organizations.list_memberships()) 
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_org_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{} = organization} = Organizations.update_organization(organization, @update_org_attrs)
      assert organization.description == "some updated description"
      assert organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization(organization, @invalid_org_attrs)
      assert organization == Organizations.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end

  describe "users" do
    @valid_user_attrs %{ email: "some email", first_name: "first_name", last_name: "last_name", password: "password", password_confirmation: "password"}
    @update_user_attrs %{ first_name: "some updated first_name", last_name: "some updated last_name" }
    @invalid_user_attrs %{ email: nil, first_name: nil, last_name: nil, password: nil, password_confirmation: nil }

    test "list_users/0 returns all users" do
      user = user_fixture()
      [found_user] = Organizations.list_users()
      assert user.id == found_user.id
      assert user.email == found_user.email
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      found_user = Organizations.get_user!(user.id)
      assert user.id == found_user.id
      assert user.email == found_user.email
    end

    test "get_user_and_organizations/1 returns the user and the organizations" do
      user = user_fixture()
      for _index <- (1..3) do
        membership_fixture()
        membership_fixture(%{ "user_id" => user.id })
      end
      organizations = Organizations.get_user_organizations(user.id)
      assert 3 == length(organizations)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Organizations.create_user(@valid_user_attrs)
      assert user.email == "some email"
      refute user.encrypted_password == nil
      assert user.first_name == "first_name"
      assert user.last_name == "last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_user(@invalid_user_attrs)
    end

    test "list_users/1 returns all the users in an organization" do
      organization = organization_fixture()
      for _index <- (1..3) do
        membership_fixture(%{ "organization_id" => organization.id })
        membership_fixture()
      end
      users = Organizations.list_users(organization.id)
      assert 3 == length(users)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Organizations.update_user(user, @update_user_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_user(user, @invalid_user_attrs)
      found_user = Organizations.get_user!(user.id)
      assert user.id == found_user.id
      assert user.email == found_user.email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Organizations.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Organizations.change_user(user)
    end
  end

  describe "memberships" do
    alias HayaiLedger.Organizations.Membership

    test "list_memberships/0 returns all memberships" do
      membership = membership_fixture()
      assert Organizations.list_memberships() == [membership]
    end

    test "list_memberships/1 returns all memberships" do
      user = user_fixture()
      for _index <- (1..3) do
        membership_fixture(%{ "user_id" => user.id })
      end
      memberships = Organizations.list_memberships_for_user(user.id)
      assert 3 == length(memberships)
    end

    test "get_membership!/1 returns the membership with given id" do
      membership = membership_fixture()
      assert Organizations.get_membership!(membership.id) == membership
    end

    test "create_membership/1 with valid data creates a membership" do
      assert {:ok, %Membership{} = membership} = Organizations.create_membership(membership_attrs())
      assert membership.active == true
    end

    test "create_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_membership(%{ organization_id: nil })
    end
  end

  describe "api_keys" do
    test "list_api_keys/0 returns all api_keys" do
      api_key = api_key_fixture()
      assert Organizations.list_api_keys() == [api_key]
    end

    test "get_api_key!/1 returns the api_key with given id" do
      api_key = api_key_fixture()
      assert Organizations.get_api_key!(api_key.id) == api_key
    end

    test "create_api_key/1 with valid data creates a api_key" do
      organization = organization_fixture()
      assert {:ok, %ApiKey{} = api_key} = Organizations.create_api_key(%{ kind: "full_api", organization_id: organization.id })
      assert {:ok, {"full_api", organization.id}} == HayaiLedger.Organizations.Encryption.verify_token(api_key.token_salt, api_key.data)
      assert api_key.active == true
      assert api_key.kind == "full_api"
    end

    test "create_api_key/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_api_key(%{ kind: nil })
    end
  end
end
