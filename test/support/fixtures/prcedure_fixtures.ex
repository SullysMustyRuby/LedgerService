defmodule Support.Fixtures.ProcedureFixtures do

	import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]

	alias HayaiLedger.Procedures

	def input_attrs() do
		%{
			"name" => "key_name",
			"procedure_id" => procedure_fixture().id
		}
	end

  def input_fixture(attrs \\ %{}) do
    {:ok, input} =
      attrs
      |> Enum.into(input_attrs())
      |> Procedures.create_input()

    input
  end

  def params_types_attrs() do
  	%{
  		"name" => "inputs"
  	}
  end

  def params_types_fixture(attrs \\ %{}) do
    {:ok, params_types} =
      attrs
      |> Enum.into(params_types_attrs())
      |> Procedures.create_params_types()

    params_types
  end

  def procedure_attrs() do
  	%{
  		"description" => "onsite cash sale",
  		"name" => "CashSale",
  		"organization_id" => organization_fixture().id,
  		"action_id" => procedure_actions_fixture().id,
  		"type_id" => procedure_types_fixture().id
  	}
  end

  def procedure_actions_attrs() do
  	%{
  		"name" => "create"
  	}
  end

  def procedure_actions_fixture(attrs \\ %{}) do
    {:ok, procedure_actions} =
      attrs
      |> Enum.into(procedure_actions_attrs())
      |> Procedures.create_procedure_actions()

    procedure_actions
  end

  def procedure_fixture(attrs \\ %{}) do
    {:ok, procedure} =
      attrs
      |> Enum.into(procedure_attrs())
      |> Procedures.create_procedure()

    procedure
  end

  def procedure_types_attrs() do
  	%{
  		"name" => "Account"
  	}
  end

  def procedure_types_fixture(attrs \\ %{}) do
    {:ok, procedure_types} =
      attrs
      |> Enum.into(procedure_types_attrs())
      |> Procedures.create_procedure_types()

    procedure_types
  end

  def type_param_attrs() do
  	%{
  		"name" => "currency",
  		"value" => "inputs['currency']",
  		"procedure_id" => procedure_fixture().id,
  		"type_id" => params_types_fixture().id
  	}
  end

  def type_param_fixture(attrs \\ %{}) do
    {:ok, type_param} =
      attrs
      |> Enum.into(type_param_attrs())
      |> Procedures.create_type_param()

    type_param
  end
end