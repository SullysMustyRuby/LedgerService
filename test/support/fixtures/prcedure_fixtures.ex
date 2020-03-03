defmodule Support.Fixtures.ProcedureFixtures do

	import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]

	alias HayaiLedger.Procedures

  def group_attrs() do
    %{ 
      "name" => "DefaultAccountSetup",
      "organization_id" => organization_fixture().id
    }
  end

  def procedure_attrs() do
  	%{
  		"description" => "onsite cash sale",
  		"name" => "CashSale",
  		"organization_id" => organization_fixture().id,
  		"action" => "create",
  		"type" => "Account"
  	}
  end

  def procedure_fixture(attrs \\ %{}) do
    {:ok, procedure} =
      attrs
      |> Enum.into(procedure_attrs())
      |> Procedures.create_procedure()

    procedure
  end

  def param_attrs() do
  	%{
  		"name" => "currency",
  		"value" => "currency",
      "type" => "inputs",
  		"procedure_id" => procedure_fixture().id,
  	}
  end

  def param_fixture(attrs \\ %{}) do
    {:ok, param} =
      attrs
      |> Enum.into(param_attrs())
      |> Procedures.create_param()

    param
  end

  ## custom procedure fixtures ##

  def account_create_procedure(organization_id) do
    {:ok, procedure} = Procedures.create_procedure(%{
      name: "DefaultBankAccount",
      description: "Create a new cash account",
      type: "Account",
      action: "create",
      organization_id: organization_id,
        params: [
        %{
          name: "currency", 
          value: "currency",
          type: "inputs"
        },
        %{
          name: "name", 
          value: "BankAccount",
          type: "default"
        },
        %{
          name: "object_type", 
          value: "Site",
          type: "default"
        },
        %{
          name: "object_uid", 
          value: "object_uid",
          type: "inputs"
        },
        %{
          name: "type", 
          value: "asset",
          type: "default"
        }
      ]
    })

    procedure
  end


  ## custom procedure params ##
  
  def account_create_params() do
    %{ 
      "name" => "DefaultBankAccount", 
      "inputs" => [
        %{ "object_uid" => "uid_kkjielkjafoie3" },
        %{ "currency" => "THB"}
      ],
    }
  end
end
