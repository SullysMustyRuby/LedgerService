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

  def account_create_params() do
    %{ 
      "name" => "DefaultBankAccount", 
      "inputs" => [
        %{ "object_uid" => "uid_kkjielkjafoie3" },
        %{ "currency" => "THB"}
      ],
    }
  end

  def account_create_procedure(organization_id) do
    {:ok, procedure} = Procedures.create_procedure(%{
      name: "DefaultBankAccount",
      description: "Create a new cash account",
      type: "Account",
      action: "create",
      organization_id: organization_id,
      inputs: [
        %{ name: "object_uid" },
        %{ name: "currency" }
        ],
        params: [
        %{
          name: "currency", 
          value: "currency",
          type: "inputs"
        },
        %{
          name: "name", 
          value: "BankAccount",
          type: "string"
        },
        %{
          name: "object_type", 
          value: "Site",
          type: "string"
        },
        %{
          name: "object_uid", 
          value: "object_uid",
          type: "inputs"
        },
        %{
          name: "type", 
          value: "asset",
          type: "string"
        }
      ]
    })

    procedure
  end

  def total_sale_procedure(organization_id, account_uid) do
    {:ok, procedure} = Procedures.create_procedure(%{
      name: "TotalSale",
      description: "total cash sale made on site",
      type: "Transaction",
      action: "build",
      organization_id: organization_id,
      inputs: [
        %{ name: "object_uid" },
        %{ name: "total_amount" }
      ],
      params: [
        %{
          name: "amount_subunits", 
          value: "total_amount",
          type: "inputs"
        },
        %{
          name: "amount_currency",
          value: "THB",
          type: "string"
        },
        %{
          name: "kind", 
          value: "debit",
          type: "string"
        },
        %{
          name: "object_uid", 
          value: "object_uid",
          type: "inputs"
        },
        %{
          name: "account_uid", 
          value: account_uid,
          type: "string"
        },
      ]
    })

    procedure
  end

  def total_sale_params() do
    %{ 
      "name" => "TotalSale", 
      "inputs" => [
        %{ "object_uid" => "uid_123456789" },
        %{ "total_amount" => "10000"}
      ],
    }
  end

  def net_sale_procedure(organization_id) do
    {:ok, procedure} = Procedures.create_procedure(%{
      name: "NetSale",
      description: "net cash sale made on site after sales tax",
      type: "Transaction",
      action: "build",
      organization_id: organization_id,
      inputs: [
        %{ name: "object_uid" },
        %{ name: "net_amount" }
      ],
      params: [
        %{
          name: "amount_subunits",
          value: "net_amount",
          type: "inputs"
        },
        %{
          name: "amount_currency",
          value: "THB",
          type: "string"
        },
        %{
          name: "kind", 
          value: "credit",
          type: "string"
        },
        %{
          name: "object_uid", 
          value: "object_uid",
          type: "inputs"
        },
        %{
          name: "account_uid", 
          value: "CashSale",
          type: "lookup"
        },
      ]
    })

    procedure
  end

  def net_sale_params() do
    %{ 
      "name" => "NetSale", 
      "inputs" => [
        %{ "object_uid" => "uid_123456789" },
        %{ "net_amount" => "9300"}
      ],
    }
  end

  def sales_tax_procedure(organization_id, account_uid) do
    {:ok, procedure} = Procedures.create_procedure(%{
      name: "SalesTax",
      description: "sales tax from cash sale on site",
      type: "Transaction",
      action: "build",
      organization_id: organization_id,
      inputs: [
        %{ name: "object_uid" },
        %{ name: "tax_amount" }
      ],
      params: [
        %{
          name: "amount_subunits",
          value: "tax_amount",
          type: "inputs"
        },
        %{
          name: "amount_currency",
          value: "THB",
          type: "string"
        },
        %{
          name: "kind", 
          value: "credit",
          type: "string"
        },
        %{
          name: "object_uid", 
          value: "object_uid",
          type: "inputs"
        },
        %{
          name: "account_uid", 
          value: "SalesTax",
          type: "lookup"
        },
      ]
    })

    procedure
  end

end
