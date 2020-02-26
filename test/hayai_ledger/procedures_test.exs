defmodule HayaiLedger.ProceduresTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]
  import Support.Fixtures.ProcedureFixtures

  alias HayaiLedger.Accounts
  alias HayaiLedger.Procedures
  alias HayaiLedger.Procedures.{Group, GroupProcedure, Param, Procedure}

  describe "groups" do

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Procedures.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Procedures.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Procedures.create_group(group_attrs())
      assert group.name == "DefaultAccountSetup"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, %Group{} = group} = Procedures.update_group(group, @update_attrs)
      assert group.name == "some updated name"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_group(group, @invalid_attrs)
      assert group == Procedures.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Procedures.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Procedures.change_group(group)
    end
  end
  
  describe "group_procedures" do

    @invalid_attrs %{ "group_id" => nil, "procedure_id" => nil }

    test "list_group_procedures/0 returns all group_procedures" do
      group_procedure = group_procedure_fixture()
      assert Procedures.list_group_procedures() == [group_procedure]
    end

    test "get_group_procedure!/1 returns the group_procedure with given id" do
      group_procedure = group_procedure_fixture()
      assert Procedures.get_group_procedure!(group_procedure.id) == group_procedure
    end

    test "create_group_procedure/1 with valid data creates a group_procedure" do
      assert {:ok, %GroupProcedure{} = group_procedure} = Procedures.create_group_procedure(group_procedure_attrs())
    end

    test "create_group_procedure/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_group_procedure(@invalid_attrs)
    end

    test "update_group_procedure/2 with valid data updates the group_procedure" do
      group_procedure = group_procedure_fixture()
      procedure = procedure_fixture()
      assert {:ok, %GroupProcedure{} = group_procedure} = Procedures.update_group_procedure(group_procedure, %{ "procedure_id" => procedure.id })
    end

    test "update_group_procedure/2 with invalid data returns error changeset" do
      group_procedure = group_procedure_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_group_procedure(group_procedure, @invalid_attrs)
      assert group_procedure == Procedures.get_group_procedure!(group_procedure.id)
    end

    test "delete_group_procedure/1 deletes the group_procedure" do
      group_procedure = group_procedure_fixture()
      assert {:ok, %GroupProcedure{}} = Procedures.delete_group_procedure(group_procedure)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_group_procedure!(group_procedure.id) end
    end

    test "change_group_procedure/1 returns a group_procedure changeset" do
      group_procedure = group_procedure_fixture()
      assert %Ecto.Changeset{} = Procedures.change_group_procedure(group_procedure)
    end
  end

  describe "params" do

    @update_attrs %{name: "some updated name", value: "some updated value"}
    @invalid_attrs %{name: nil, value: nil}

    test "list_params/0 returns all params" do
      param = param_fixture()
      assert Procedures.list_params() == [param]
    end

    test "get_param!/1 returns the param with given id" do
      param = param_fixture()
      assert Procedures.get_param!(param.id) == param
    end

    test "create_param/1 with valid data creates a param" do
      assert {:ok, %Param{} = param} = Procedures.create_param(param_attrs())
      assert param.name == "currency"
      assert param.value == "currency"
    end

    test "create_param/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_param(@invalid_attrs)
    end

    test "update_param/2 with valid data updates the param" do
      param = param_fixture()
      assert {:ok, %Param{} = param} = Procedures.update_param(param, @update_attrs)
      assert param.name == "some updated name"
      assert param.value == "some updated value"
    end

    test "update_param/2 with invalid data returns error changeset" do
      param = param_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_param(param, @invalid_attrs)
      assert param == Procedures.get_param!(param.id)
    end

    test "delete_param/1 deletes the param" do
      param = param_fixture()
      assert {:ok, %Param{}} = Procedures.delete_param(param)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_param!(param.id) end
    end

    test "change_param/1 returns a param changeset" do
      param = param_fixture()
      assert %Ecto.Changeset{} = Procedures.change_param(param)
    end
  end

  describe "procedures" do

    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    test "list_procedures/0 returns all procedures" do
      procedure = procedure_fixture()
      assert Procedures.list_procedures() == [procedure]
    end

    test "get_procedure!/1 returns the procedure with given id" do
      procedure = procedure_fixture()
      found_procedure = Procedures.get_procedure!(procedure.id)
      assert procedure.organization_id == found_procedure.organization_id
      assert procedure.name == found_procedure.name
    end

    test "create_procedure/1 with valid data creates a procedure" do
      assert {:ok, %Procedure{} = procedure} = Procedures.create_procedure(procedure_attrs())
      assert procedure.description == "onsite cash sale"
      assert procedure.name == "CashSale"
    end

    test "create_procedure/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_procedure(@invalid_attrs)
    end

    test "update_procedure/2 with valid data updates the procedure" do
      procedure = procedure_fixture()
      assert {:ok, %Procedure{} = procedure} = Procedures.update_procedure(procedure, @update_attrs)
      assert procedure.description == "some updated description"
      assert procedure.name == "some updated name"
    end

    test "update_procedure/2 with invalid data returns error changeset" do
      procedure = procedure_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_procedure(procedure, @invalid_attrs)
      found_procedure = Procedures.get_procedure!(procedure.id)
      assert procedure.organization_id == found_procedure.organization_id
      assert procedure.name == found_procedure.name
    end

    test "delete_procedure/1 deletes the procedure" do
      procedure = procedure_fixture()
      assert {:ok, %Procedure{}} = Procedures.delete_procedure(procedure)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_procedure!(procedure.id) end
    end

    test "change_procedure/1 returns a procedure changeset" do
      procedure = procedure_fixture()
      assert %Ecto.Changeset{} = Procedures.change_procedure(procedure)
    end
  end

  describe "get_procedure_by_name/2" do
    setup do
       %{ organization: organization_fixture() }
    end

    test "returns the procedure", %{ organization: organization } do
      account_create_procedure(organization.id)
      {:ok, procedure} = Procedures.get_procedure_by_name("DefaultBankAccount", organization.id)

      assert procedure.name == "DefaultBankAccount"
      assert procedure.organization_id == organization.id
      assert 5 == length(procedure.params)
    end

    test "returns error if no process for the procedure", %{ organization: organization } do
      assert {:error, "no process for that procedure"} == Procedures.get_procedure_by_name("DestroyDatabase", organization.id)
    end
  end

  describe "process/2" do
    setup do
      %{ organization: organization_fixture() }
    end

    test "returns the account for an account create", %{ organization: organization } do
      account_create_procedure(organization.id) 
      assert {:ok, account} = Procedures.process(account_create_params(), organization.id)

      assert "THB" == account.currency
      assert "asset" == account.type
      assert "BankAccount" == account.name
      assert "Site" == account.object_type
      assert "uid_kkjielkjafoie3" == account.object_uid
    end

    test "returns a changeset for an transaction build", %{ organization: organization } do
      account_create_procedure(organization.id)
      {:ok, account} = Procedures.process(account_create_params(), organization.id)
      total_sale_procedure(organization.id, account.uid)

      assert {:ok, changeset} = Procedures.process(total_sale_params(), organization.id)
      assert changeset.valid?
      assert "THB" == changeset.changes[:amount_currency]
      assert 10000 == changeset.changes[:amount_subunits]
      assert "debit" == changeset.changes[:kind]
    end

    test "looks up account for a transaction build", %{ organization: organization } do
      account_params = %{
        "currency" => "THB",
        "name" => "CashSale",
        "object_type" => "Account",
        "object_uid" => "uid_123456789",
        "type" => "revenue",
        "organization_id" => organization.id
      }
      {:ok, account} = Accounts.create_account(account_params)
      net_sale_procedure(organization.id)

      assert {:ok, changeset} = Procedures.process(net_sale_params(), organization.id)
      assert changeset.valid?
      assert "THB" == changeset.changes[:amount_currency]
      assert 9300 == changeset.changes[:amount_subunits]
      assert "credit" == changeset.changes[:kind]
      assert account.id == changeset.changes[:account_id]
    end

    test "returns an changeset for entry build", %{ organization: organization } do
      sale_entry_procedure(organization.id)

      assert {:ok, changeset} = Procedures.process(sale_entry_params(), organization.id)
      assert changeset.valid?
      assert organization.id == changeset.changes[:organization_id]
      assert "cash sale" == changeset.changes[:description]
      assert "uid_123456789" == changeset.changes[:object_uid]
      assert "Sale" == changeset.changes[:object_type]
    end

    test "returns an full entry from journal_entry", %{ organization: organization } do
      asset_account = create_account("Cash", "uid_123456789", "asset", organization.id)
      create_account("CashSale", "uid_123456789", "revenue", organization.id)
      tax_account = create_account("SalesTax", "uid_123456789", "liability", organization.id)

      total_sale_procedure(organization.id, asset_account.uid)
      net_sale_procedure(organization.id)
      sales_tax_procedure(organization.id, tax_account.uid)
      sale_entry_procedure(organization.id)

      {:ok, entry, transactions} = Procedures.process(journal_entry_params(), organization.id)
      assert organization.id == entry.organization_id
      assert "cash sale" == entry.description
      assert "uid_123456789" == entry.object_uid
      assert "Sale" == entry.object_type 
      assert 3 == length(transactions)
    end
  end

  defp create_account(name, object_uid, type, organization_id) do
    {:ok, account} = Accounts.create_account(%{
      "currency" => "THB",
      "name" => name,
      "object_type" => "Account",
      "object_uid" => object_uid,
      "type" => type,
      "organization_id" => organization_id
    })
    
    account
  end
end
