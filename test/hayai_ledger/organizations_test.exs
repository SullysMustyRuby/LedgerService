defmodule HayaiLedger.OrganizationsTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Organizations

  describe "organizations" do
    alias HayaiLedger.Organizations.Organization

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def organization_fixture(attrs \\ %{}) do
      {:ok, organization} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organizations.create_organization()

      organization
    end

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Organizations.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} = Organizations.create_organization(@valid_attrs)
      assert organization.description == "some description"
      assert organization.name == "some name"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{} = organization} = Organizations.update_organization(organization, @update_attrs)
      assert organization.description == "some updated description"
      assert organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization(organization, @invalid_attrs)
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
    alias HayaiLedger.Organizations.User

    @valid_attrs %{ email: "some email", first_name: "first_name", last_name: "last_name", password: "password", password_confirmation: "password"}
    @update_attrs %{ first_name: "some updated first_name", last_name: "some updated last_name" }
    @invalid_attrs %{ email: nil, first_name: nil, last_name: nil, password: nil, password_confirmation: nil }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organizations.create_user()

      user
    end

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

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Organizations.create_user(@valid_attrs)
      assert user.email == "some email"
      refute user.encrypted_password == nil
      assert user.first_name == "first_name"
      assert user.last_name == "last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Organizations.update_user(user, @update_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_user(user, @invalid_attrs)
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
end
