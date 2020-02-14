defmodule HayaiLedger.AccountsTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.AccountFixtures

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.{Account, AccountType}

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
      assert {:ok, %Account{} = account} = Accounts.create_account(account_attrs())
      assert account.name == "some name"
      assert account.uid != nil
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(%{ kind: nil })
    end
  end

  describe "create_account_type/1" do
    test "with valid data creates a account_type" do
      assert {:ok, %AccountType{} = account_type} = Accounts.create_account_type(account_type_attrs())
      assert account_type.name == "cash"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account_type(%{ name: nil })
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

  describe "get_account_uid/1" do
    test "returns the uid for the account id" do
      account = account_fixture()
      assert account.uid == Accounts.get_account_uid(account.id)
    end

    test "returns nil if account not found" do
      assert nil == Accounts.get_account_uid(555)
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
      update_account_attrs = %{ meta_data: %{}, kind: "asset", name: "some updated name", object_type: "some updated object_type", object_uid: "some updated object_uid", uid: "some updated uid" }
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_account_attrs)
      assert account.meta_data == %{}
      assert account.name == "some updated name"
      assert account.object_type == "some updated object_type"
      assert account.object_uid == "some updated object_uid"
      assert account.uid != nil
    end

    test "with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, %{ currency: nil })
      assert account == Accounts.get_account!(account.id)
    end
  end

  describe "update_account_type/2" do
    test "with valid data updates the account_type" do
      account_type = account_type_fixture()
      update_type_attrs = %{ description: "some updated description" }
      assert {:ok, %AccountType{} = account_type} = Accounts.update_account_type(account_type, update_type_attrs)
      assert account_type.description == "some updated description"
      assert account_type.name == "cash"
    end

    test "with invalid data returns error changeset" do
      account_type = account_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account_type(account_type, %{ name: nil })
      assert account_type == Accounts.get_account_type!(account_type.id)
    end
  end
end
