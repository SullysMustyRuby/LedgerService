defmodule HayaiLedger.ProceduresTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]
  import Support.Fixtures.ProcedureFixtures

  alias HayaiLedger.Procedures
  alias HayaiLedger.Procedures.{Param, Procedure}

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
  end

  # defp create_account(name, object_uid, type, organization_id) do
  #   {:ok, account} = Accounts.create_account(%{
  #     "currency" => "THB",
  #     "name" => name,
  #     "object_type" => "Account",
  #     "object_uid" => object_uid,
  #     "type" => type,
  #     "organization_id" => organization_id
  #   })
    
  #   account
  # end
end
