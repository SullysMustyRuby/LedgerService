defmodule HayaiLedger.AccountsTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.{Account, AccountType}

  @update_account_attrs %{ meta_data: %{}, name: "some updated name", object_type: "some updated object_type", object_uid: "some updated object_uid", uid: "some updated uid" }
  @invalid_account_attrs %{ currency: nil, name: nil, type_id: nil }

  @valid_type_attrs %{ description: "some description", name: "some name", currency: "JPY" }
  @update_type_attrs %{ description: "some updated description", name: "some updated name" }
  @invalid_type_attrs %{ name: nil }

  describe "change_account/1" do
    test "returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "change_account_type/1" do
    test "returns a account_type changeset" do
      account_type = account_type_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account_type(account_type)
    end
  end

  describe "create_account/1" do
    test "with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(valid_account_attrs())
      assert account.meta_data == %{}
      assert account.name == "some name"
      assert account.object_type == "some object_type"
      assert account.object_uid == "some object_uid"
      assert account.uid != nil
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_account_attrs)
    end
  end

  describe "create_account_type/1" do
    test "with valid data creates a account_type" do
      assert {:ok, %AccountType{} = account_type} = Accounts.create_account_type(@valid_type_attrs)
      assert account_type.description == "some description"
      assert account_type.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account_type(@invalid_type_attrs)
    end
  end

  describe "delete_account/1" do
    # test "deletes the account" do
    #   account = account_fixture()
    #   assert {:ok, %Account{}} = Accounts.delete_account(account)
    #   assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    # end
  end

  describe "delete_account_type/1" do
    # test "deletes the account_type" do
    #   account_type = account_type_fixture()
    #   assert {:ok, %AccountType{}} = Accounts.delete_account_type(account_type)
    #   assert_raise Ecto.NoResultsError, fn -> Accounts.get_account_type!(account_type.id) end
    # end
  end

  describe "get_account!/1" do
    test "returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end
  end

  describe "get_account_type!/1" do
    test "returns the account_type with given id" do
      account_type = account_type_fixture()
      assert Accounts.get_account_type!(account_type.id) == account_type
    end
  end

  describe "list_accounts/0" do
    test "returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end
  end

  describe "list_account_types/0" do
    test "returns all account_types" do
      account_type = account_type_fixture()
      assert Accounts.list_account_types() == [account_type]
    end
  end

  describe "update_account/2" do
    test "uwith valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_account_attrs)
      assert account.meta_data == %{}
      assert account.name == "some updated name"
      assert account.object_type == "some updated object_type"
      assert account.object_uid == "some updated object_uid"
      assert account.uid != nil
    end

    test "with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_account_attrs)
      assert account == Accounts.get_account!(account.id)
    end
  end

  describe "update_account_type/2" do
    test "with valid data updates the account_type" do
      account_type = account_type_fixture()
      assert {:ok, %AccountType{} = account_type} = Accounts.update_account_type(account_type, @update_type_attrs)
      assert account_type.description == "some updated description"
      assert account_type.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      account_type = account_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account_type(account_type, @invalid_type_attrs)
      assert account_type == Accounts.get_account_type!(account_type.id)
    end
  end

  defp account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(valid_account_attrs())
      |> Accounts.create_account()

    account
  end

  defp account_type_fixture(attrs \\ %{}) do
    {:ok, account_type} =
      attrs
      |> Enum.into(@valid_type_attrs)
      |> Accounts.create_account_type()

    account_type
  end

  defp create_account_type() do
    {:ok, type} = HayaiLedger.Accounts.create_account_type(%{ name: "cash" })
    type
  end

  defp valid_account_attrs() do
    %{
      currency: "JPY",
      meta_data: %{}, 
      name: "some name", 
      object_type: "some object_type", 
      object_uid: "some object_uid",
      type_id: create_account_type().id, 
      uid: "some uid"
    }
  end
end
