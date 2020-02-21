defmodule HayaiLedger.ProceduresTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.ProcedureFixtures

  alias HayaiLedger.Procedures
  alias HayaiLedger.Procedures.{Input, ParamsType, Procedure, ProcedureAction, ProcedureType, TypeParam}

  describe "procedure_types" do

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_procedure_types/0 returns all procedure_types" do
      procedure_types = procedure_types_fixture()
      assert Procedures.list_procedure_types() == [procedure_types]
    end

    test "get_procedure_types!/1 returns the procedure_types with given id" do
      procedure_types = procedure_types_fixture()
      assert Procedures.get_procedure_types!(procedure_types.id) == procedure_types
    end

    test "create_procedure_types/1 with valid data creates a procedure_types" do
      assert {:ok, %ProcedureType{} = procedure_types} = Procedures.create_procedure_types(procedure_types_attrs())
      assert procedure_types.name == "Account"
    end

    test "create_procedure_types/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_procedure_types(@invalid_attrs)
    end

    test "update_procedure_types/2 with valid data updates the procedure_types" do
      procedure_types = procedure_types_fixture()
      assert {:ok, %ProcedureType{} = procedure_types} = Procedures.update_procedure_types(procedure_types, @update_attrs)
      assert procedure_types.name == "some updated name"
    end

    test "update_procedure_types/2 with invalid data returns error changeset" do
      procedure_types = procedure_types_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_procedure_types(procedure_types, @invalid_attrs)
      assert procedure_types == Procedures.get_procedure_types!(procedure_types.id)
    end

    test "delete_procedure_types/1 deletes the procedure_types" do
      procedure_types = procedure_types_fixture()
      assert {:ok, %ProcedureType{}} = Procedures.delete_procedure_types(procedure_types)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_procedure_types!(procedure_types.id) end
    end

    test "change_procedure_types/1 returns a procedure_types changeset" do
      procedure_types = procedure_types_fixture()
      assert %Ecto.Changeset{} = Procedures.change_procedure_types(procedure_types)
    end
  end

  describe "procedure_actions" do

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}


    test "list_procedure_actions/0 returns all procedure_actions" do
      procedure_actions = procedure_actions_fixture()
      assert Procedures.list_procedure_actions() == [procedure_actions]
    end

    test "get_procedure_actions!/1 returns the procedure_actions with given id" do
      procedure_actions = procedure_actions_fixture()
      assert Procedures.get_procedure_actions!(procedure_actions.id) == procedure_actions
    end

    test "create_procedure_actions/1 with valid data creates a procedure_actions" do
      assert {:ok, %ProcedureAction{} = procedure_actions} = Procedures.create_procedure_actions(procedure_actions_attrs())
      assert procedure_actions.name == "create"
    end

    test "create_procedure_actions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_procedure_actions(@invalid_attrs)
    end

    test "update_procedure_actions/2 with valid data updates the procedure_actions" do
      procedure_actions = procedure_actions_fixture()
      assert {:ok, %ProcedureAction{} = procedure_actions} = Procedures.update_procedure_actions(procedure_actions, @update_attrs)
      assert procedure_actions.name == "some updated name"
    end

    test "update_procedure_actions/2 with invalid data returns error changeset" do
      procedure_actions = procedure_actions_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_procedure_actions(procedure_actions, @invalid_attrs)
      assert procedure_actions == Procedures.get_procedure_actions!(procedure_actions.id)
    end

    test "delete_procedure_actions/1 deletes the procedure_actions" do
      procedure_actions = procedure_actions_fixture()
      assert {:ok, %ProcedureAction{}} = Procedures.delete_procedure_actions(procedure_actions)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_procedure_actions!(procedure_actions.id) end
    end

    test "change_procedure_actions/1 returns a procedure_actions changeset" do
      procedure_actions = procedure_actions_fixture()
      assert %Ecto.Changeset{} = Procedures.change_procedure_actions(procedure_actions)
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
      assert Procedures.get_procedure!(procedure.id) == procedure
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
      assert procedure == Procedures.get_procedure!(procedure.id)
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

  describe "params_types" do

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_params_types/0 returns all params_types" do
      params_types = params_types_fixture()
      assert Procedures.list_params_types() == [params_types]
    end

    test "get_params_types!/1 returns the params_types with given id" do
      params_types = params_types_fixture()
      assert Procedures.get_params_types!(params_types.id) == params_types
    end

    test "create_params_types/1 with valid data creates a params_types" do
      assert {:ok, %ParamsType{} = params_types} = Procedures.create_params_types(params_types_attrs())
      assert params_types.name == "inputs"
    end

    test "create_params_types/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_params_types(@invalid_attrs)
    end

    test "update_params_types/2 with valid data updates the params_types" do
      params_types = params_types_fixture()
      assert {:ok, %ParamsType{} = params_types} = Procedures.update_params_types(params_types, @update_attrs)
      assert params_types.name == "some updated name"
    end

    test "update_params_types/2 with invalid data returns error changeset" do
      params_types = params_types_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_params_types(params_types, @invalid_attrs)
      assert params_types == Procedures.get_params_types!(params_types.id)
    end

    test "delete_params_types/1 deletes the params_types" do
      params_types = params_types_fixture()
      assert {:ok, %ParamsType{}} = Procedures.delete_params_types(params_types)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_params_types!(params_types.id) end
    end

    test "change_params_types/1 returns a params_types changeset" do
      params_types = params_types_fixture()
      assert %Ecto.Changeset{} = Procedures.change_params_types(params_types)
    end
  end

  describe "type_params" do

    @update_attrs %{name: "some updated name", value: "some updated value"}
    @invalid_attrs %{name: nil, value: nil}

    test "list_type_params/0 returns all type_params" do
      type_param = type_param_fixture()
      assert Procedures.list_type_params() == [type_param]
    end

    test "get_type_param!/1 returns the type_param with given id" do
      type_param = type_param_fixture()
      assert Procedures.get_type_param!(type_param.id) == type_param
    end

    test "create_type_param/1 with valid data creates a type_param" do
      assert {:ok, %TypeParam{} = type_param} = Procedures.create_type_param(type_param_attrs())
      assert type_param.name == "currency"
      assert type_param.value == "inputs['currency']"
    end

    test "create_type_param/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Procedures.create_type_param(@invalid_attrs)
    end

    test "update_type_param/2 with valid data updates the type_param" do
      type_param = type_param_fixture()
      assert {:ok, %TypeParam{} = type_param} = Procedures.update_type_param(type_param, @update_attrs)
      assert type_param.name == "some updated name"
      assert type_param.value == "some updated value"
    end

    test "update_type_param/2 with invalid data returns error changeset" do
      type_param = type_param_fixture()
      assert {:error, %Ecto.Changeset{}} = Procedures.update_type_param(type_param, @invalid_attrs)
      assert type_param == Procedures.get_type_param!(type_param.id)
    end

    test "delete_type_param/1 deletes the type_param" do
      type_param = type_param_fixture()
      assert {:ok, %TypeParam{}} = Procedures.delete_type_param(type_param)
      assert_raise Ecto.NoResultsError, fn -> Procedures.get_type_param!(type_param.id) end
    end

    test "change_type_param/1 returns a type_param changeset" do
      type_param = type_param_fixture()
      assert %Ecto.Changeset{} = Procedures.change_type_param(type_param)
    end
  end
end
