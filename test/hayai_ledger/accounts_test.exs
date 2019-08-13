defmodule HayaiLedger.AccountsTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Accounts

  describe "account_types" do
    alias HayaiLedger.Accounts.AccountType

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def account_type_fixture(attrs \\ %{}) do
      {:ok, account_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account_type()

      account_type
    end

    test "list_account_types/0 returns all account_types" do
      account_type = account_type_fixture()
      assert Accounts.list_account_types() == [account_type]
    end

    test "get_account_type!/1 returns the account_type with given id" do
      account_type = account_type_fixture()
      assert Accounts.get_account_type!(account_type.id) == account_type
    end

    test "create_account_type/1 with valid data creates a account_type" do
      assert {:ok, %AccountType{} = account_type} = Accounts.create_account_type(@valid_attrs)
      assert account_type.description == "some description"
      assert account_type.name == "some name"
    end

    test "create_account_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account_type(@invalid_attrs)
    end

    test "update_account_type/2 with valid data updates the account_type" do
      account_type = account_type_fixture()
      assert {:ok, %AccountType{} = account_type} = Accounts.update_account_type(account_type, @update_attrs)
      assert account_type.description == "some updated description"
      assert account_type.name == "some updated name"
    end

    test "update_account_type/2 with invalid data returns error changeset" do
      account_type = account_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account_type(account_type, @invalid_attrs)
      assert account_type == Accounts.get_account_type!(account_type.id)
    end

    test "delete_account_type/1 deletes the account_type" do
      account_type = account_type_fixture()
      assert {:ok, %AccountType{}} = Accounts.delete_account_type(account_type)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account_type!(account_type.id) end
    end

    test "change_account_type/1 returns a account_type changeset" do
      account_type = account_type_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account_type(account_type)
    end
  end

  describe "accounts" do
    alias HayaiLedger.Accounts.Account

    @valid_attrs %{meta_data: %{}, name: "some name", object_type: "some object_type", object_uid: "some object_uid", uid: "some uid"}
    @update_attrs %{meta_data: %{}, name: "some updated name", object_type: "some updated object_type", object_uid: "some updated object_uid", uid: "some updated uid"}
    @invalid_attrs %{meta_data: nil, name: nil, object_type: nil, object_uid: nil, uid: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.meta_data == %{}
      assert account.name == "some name"
      assert account.object_type == "some object_type"
      assert account.object_uid == "some object_uid"
      assert account.uid == "some uid"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.meta_data == %{}
      assert account.name == "some updated name"
      assert account.object_type == "some updated object_type"
      assert account.object_uid == "some updated object_uid"
      assert account.uid == "some updated uid"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
