defmodule HayaiLedger.ProceduresTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]
  import Support.Fixtures.ProcedureFixtures

  alias HayaiLedger.Procedures
  alias HayaiLedger.Procedures.{Input, Procedure, Param}

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

  describe "inputs" do

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_inputs/0 returns all inputs" do
      input = input_fixture()
      assert Procedures.list_inputs() == [input]
    end

    test "get_input!/1 returns the input with given id" do
      input = input_fixture()
      assert Procedures.get_input!(input.id) == input
    end

    test "create_input/1 with valid data creates a input" do
      assert {:ok, %Input{} = input} = Procedures.create_input(input_attrs())
      assert input.name ==  "key_name"
    end

    test "create_input/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_input(@invalid_attrs)
    end

    test "update_input/2 with valid data updates the input" do
      input = input_fixture()
      assert {:ok, %Input{} = input} = Procedures.update_input(input, @update_attrs)
      assert input.name == "some updated name"
    end

    test "update_input/2 with invalid data returns error changeset" do
      input = input_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_input(input, @invalid_attrs)
      assert input == Procedures.get_input!(input.id)
    end

    test "delete_input/1 deletes the input" do
      input = input_fixture()
      assert {:ok, %Input{}} = Procedures.delete_input(input)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_input!(input.id) end
    end

    test "change_input/1 returns a input changeset" do
      input = input_fixture()
      assert %Ecto.Changeset{} = Procedures.change_input(input)
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

  describe "get_procedure_by_name/2" do
    setup do
       %{ organization: organization_fixture() }
    end

    test "returns the procedure", %{ organization: organization } do
      account_create_procedure(organization.id)
      {:ok, procedure} = Procedures.get_procedure_by_name("DefaultBankAccount", organization.id)

      assert procedure.name == "DefaultBankAccount"
      assert procedure.organization_id == organization.id
      assert length(inputs()) == length(procedure.inputs)
      assert length(params()) == length(procedure.params)
    end

    test "returns error if no process for the procedure", %{ organization: organization } do
      assert {:error, "no process for that procedure"} == Procedures.get_procedure_by_name("DestroyDatabase", organization.id)
    end
  end

  describe "process/2" do
    test "returns the account for an account create" do
      organization = organization_fixture()
      account_create_procedure(organization.id) 

      Procedures.process(account_create_params(), organization.id)
    end
  end
end
