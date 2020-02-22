defmodule HayaiLedger.AccountsTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.AccountFixtures
  import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]
  import Support.Fixtures.ProcedureFixtures, only: [{:account_create_procedure, 1}, {:account_create_params, 0}]

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.{Balance, Account}

  describe "active_accounts_exist?/1" do
    test "returns true if an account exists within the object_uid" do
      account_fixture(%{ "name" => "Cash", "object_uid" => "uid_12345678" })
      assert Accounts.active_accounts_exist?(%{ name: "Cash", object_uid: "uid_12345678" })
      refute Accounts.active_accounts_exist?(%{ name: "Cash2", object_uid: "uid_12345678" })
    end

    test "returns true if an account exists within the organization_id" do
      organization = organization_fixture()
      account_fixture(%{ "name" => "Cash", "organization_id" => organization.id })
      assert Accounts.active_accounts_exist?(%{ name: "Cash", organization_id: organization.id })
      refute Accounts.active_accounts_exist?(%{ name: "Cash2", organization_id: organization.id })
    end
  end

  describe "balance_amount_subunits_for_account/1" do
    test "returns the amount_subunits" do
      account = account_fixture()
      Accounts.update_balance(account.id, 5000)
      assert 5000 == Accounts.balance_amount_subunits_for_account(account.id)
    end

    test "returns nil if no account found" do
      assert nil == Accounts.balance_amount_subunits_for_account("555")
    end
  end

  describe "change_account/1" do
    test "returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "create_account/1" do
    test "with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(account_attrs())
      assert account.name == "some name"
      assert account.uid != nil
    end

    test "creates a balance account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(account_attrs())
      balance = Accounts.get_balance_by_account(account.id)
      assert account.id == balance.account_id
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(%{ kind: nil })
    end
  end

  describe "create_account/2" do
    setup do
      %{ organization: organization_fixture() }
    end
    test "with valid data creates an account and assigns the organization", %{ organization: organization } do
      assert {:ok, %Account{} = account} = Accounts.create_account(account_attrs(), organization.id)
      assert account.name == "some name"
      assert account.organization_id == organization.id
    end

    test "creates a balance account", %{ organization: organization } do
      assert {:ok, %Account{} = account} = Accounts.create_account(account_attrs(), organization.id)
      balance = Accounts.get_balance_by_account(account.id)
      assert account.id == balance.account_id
    end

    test "with invalid data returns error changeset", %{ organization: organization } do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(%{ "kind" => nil }, organization.id)
    end
  end

  describe "create_balance/1 " do
    test "with valid data creates a balance" do
      account = account_fixture(account_attrs())
      attrs = %{
        account_id: account.id,
        amount_currency: account.currency,
        amount_subunits: 0
      }
      assert {:ok, %Balance{} = balance} = Accounts.create_balance(attrs)
      assert balance.amount_subunits == 0
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_balance(%{ amount_currency: nil })
    end
  end

  describe "get_balance!/1 " do
    test "returns the balance with given id" do
      account = account_fixture()
      balance = balance_fixture(%{ "account_id" => account.id })
      assert Accounts.get_balance!(balance.id) == balance
    end
  end

  describe "get_balance_by_account/1" do
    test "returns the balance" do
      account = account_fixture()
      found_balance = Accounts.get_balance_by_account(account.id)
      assert account.id == found_balance.account_id
    end

    test "returns nil when account not found" do
       assert nil == Accounts.get_balance_by_account("555")
    end
  end

  describe "get_account!/1" do
    test "returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
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

  describe "handle_procedure/2" do
    setup do
      organization = organization_fixture()
      %{
        organization: organization,
        procedure: account_create_procedure(organization.id)
      }
    end

    test "creates an account with the args provided", %{ organization: organization, procedure: procedure } do
      %{ "inputs" => inputs } = account_create_params()
      {:ok, account} = Accounts.handle_procedure(procedure, inputs, organization.id)
      assert "BankAccount" == account.name
      assert "THB" == account.currency
      assert "uid_kkjielkjafoie3" == account.object_uid
      assert "Site" == account.object_type
      assert "asset" == account.type
    end
  end

  describe "list_balances/0" do
    test "returns all balances" do
      balance = balance_fixture()
      balances = Accounts.list_balances()
      assert Enum.member?(balances, balance)
    end
  end

  describe "list_accounts/0" do
    test "returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
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

  describe "update_balance/2" do
    test "with valid data updates the balance" do
      account = account_fixture()
      assert {:ok, %Balance{} = balance} = Accounts.update_balance(account.id, 5000)
      assert balance.amount_subunits == 5000
    end

    test "with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_balance(account.id, "abcde")
      # assert balance == Accounts.get_balance!(balance.id)
    end
  end
end
