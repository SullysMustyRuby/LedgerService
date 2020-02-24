# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HayaiLedger.Repo.insert!(%HayaiLedger.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HayaiLedger.Organizations
alias HayaiLedger.Procedures

{:ok, user} = %{ 
	"email" => "sullymustycode@gmail.com", 
	"first_name" => "erin", 
	"last_name" => "boeger", 
	"password" => "Password", 
	"password_confirmation" => "Password"
}
|> Organizations.create_user()

{:ok, organization} = %{
	"description" => "The best ledger system perid!", 
	"name" => "HaiyaiLedger"
}
|> Organizations.create_organization()

%{
  "organization_id" => organization.id,
  "user_id" => user.id
}
|> Organizations.create_membership()

%{
  "kind" => "full_api",
  "organization_id" => organization.id
}
|> Organizations.create_api_key()

### asset account procedures ###

inputs = [
      %{ name: "object_uid" },
      %{ name: "currency" }
    ]

{:ok, bank_asset} = %{
  name: "DefaultBankAsset",
  description: "Create a new bank account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
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
}
|> Procedures.create_procedure()

{:ok, cash_asset} = %{
  name: "DefaultCashAsset",
  description: "Create a new cash account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "Cash",
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
}
|> Procedures.create_procedure()

{:ok, equimpent_asset} = %{
  name: "DefaultEquipmentAsset",
  description: "Create a new equpment account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "Equipment",
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
}
|> Procedures.create_procedure()

{:ok, food_asset} = %{
  name: "DefaultFoodAsset",
  description: "Create a new food inventory account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "FoodInventory",
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
}
|> Procedures.create_procedure()

{:ok, supplies_asset} = %{
  name: "DefaultSuppliesAsset",
  description: "Create a new supplies inventory account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "SuppliesInventory",
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
}
|> Procedures.create_procedure()

### expense account prcedures ###

{:ok, wage_expenses} = %{
  name: "DefaultWageExpense",
  description: "Create a new wages expense account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "Wages",
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
      value: "expense",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, other_expenses} = %{
  name: "DefaultOtherExpense",
  description: "Create a new other expense account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "OtherExpense",
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
      value: "expense",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

### liability account procedures ###

{:ok, equimpment_vendor} = %{
  name: "DefaultEquipmentVendorLiability",
  description: "Create a new equpment vendor account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "EquipmentVendor",
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
      value: "liability",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, food_vendor} = %{
  name: "DefaultFoodVendorLiability",
  description: "Create a new food vendor account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "FoodVendor",
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
      value: "liability",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, gross_labor} = %{
  name: "DefaultGrossLaborLiability",
  description: "Create a new gross labor account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "Grosslabor",
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
      value: "liability",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, sales_tax} = %{
  name: "DefaultSalesTaxLiability",
  description: "Create a new sales tax liability account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "SalesTax",
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
      value: "liability",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, supply_vendor} = %{
  name: "DefaultSupplyVendorLiability",
  description: "Create a new supply vendor liability account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "SupplyVendor",
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
      value: "liability",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

# revenue account procedures

{:ok, cash_revenue} = %{
  name: "DefaultCashSalesRevenue",
  description: "Create a new sales revenue account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "CashSales",
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
      value: "revenue",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, cash_revenue} = %{
  name: "DefaultCreditCardSalesRevenue",
  description: "Create a new credit card revenue account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "CreditCardSales",
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
      value: "revenue",
      type: "string"
    }
  ]
}
|> Procedures.create_procedure()

### credit procedures ###

{:ok, credit_cash} = %{
  name: "CreditCash",
  description: "credit the asset cash account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "cash_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "cash_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "Cash",
      type: "lookup"
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
      value: "Cash",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, credit_cash_sales} = %{
  name: "CreditCashSales",
  description: "credit the revenue cash account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "cash_sales_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "cash_sales_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "CashSales",
      type: "lookup"
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
      value: "CashSales",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, credit_food_vendor} = %{
  name: "CreditFoodVendor",
  description: "credit the food vendor liability account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "food_vendor_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "food_vendor_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "FoodVendor",
      type: "lookup"
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
      value: "FoodVendor",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, credit_gross_labor} = %{
  name: "CreditGrosslabor",
  description: "credit the gross labor liability account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "gross_labor_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "gross_labor_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "Grosslabor",
      type: "lookup"
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
      value: "Grosslabor",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, credit_sales_tax} = %{
  name: "CreditSalesTax",
  description: "credit the sales tax liability account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "sales_tax_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "sales_tax_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "SalesTax",
      type: "lookup"
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
}
|> Procedures.create_procedure()

{:ok, credit_supply_vendor} = %{
  name: "CreditSupplyVendor",
  description: "credit the supply vendor liability account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "supply_vendor_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "supply_vendor_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "SupplyVendor",
      type: "lookup"
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
      value: "SupplyVendor",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

### debit procedures ###

{:ok, debit_bank_account} = %{
  name: "DebitBankAccount",
  description: "Debit the asset bank account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "bank_account_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "bank_account_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "BankAccount",
      type: "lookup"
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
      value: "BankAccount",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, debit_cash_account} = %{
  name: "DebitCash",
  description: "Debit the asset cash account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "cash_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "cash_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "Cash",
      type: "lookup"
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
      value: "Cash",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, debit_cash_account} = %{
  name: "DebitFoodInventory",
  description: "Debit the asset food inventory account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "food_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "food_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "FoodInventory",
      type: "lookup"
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
      value: "FoodInventory",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, debit_supplies_inventory} = %{
  name: "DebitSuppliesInventory",
  description: "Debit the asset supplies inventory account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "supplies_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "supplies_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "SuppliesInventory",
      type: "lookup"
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
      value: "SuppliesInventory",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, debit_wages} = %{
  name: "DebitWages",
  description: "Debit the wages account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "object_uid" },
    %{ name: "wages_amount" }
  ],
  params: [
    %{
      name: "amount_subunits",
      value: "wages_amount",
      type: "inputs"
    },
    %{
      name: "amount_currency",
      value: "Wages",
      type: "lookup"
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
      value: "Wages",
      type: "lookup"
    },
  ]
}
|> Procedures.create_procedure()

### Entry procedures ###

%{
  name: "JournalEntry",
  description: "entry for journal entry with transactions",
  type: "Entry",
  action: "build",
  organization_id: organization.id,
  inputs: [
    %{ name: "description" },
    %{ name: "object_type" },
    %{ name: "object_uid" }
  ],
  params: [
    %{
      name: "description", 
      value: "description",
      type: "inputs"
    },
    %{
      name: "object_type", 
      value: "object_type",
      type: "inputs"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    },
  ]
}
|> Procedures.create_procedure()