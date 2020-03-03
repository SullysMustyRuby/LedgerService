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

{:ok, bank_asset} = %{
  name: "DefaultBankAsset",
  description: "Create a new bank account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
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
}
|> Procedures.create_procedure()

{:ok, cash_asset} = %{
  name: "DefaultCashAsset",
  description: "Create a new cash account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "Cash",
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
}
|> Procedures.create_procedure()

{:ok, equimpent_asset} = %{
  name: "DefaultEquipmentAsset",
  description: "Create a new equpment account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "Equipment",
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
}
|> Procedures.create_procedure()

{:ok, food_asset} = %{
  name: "DefaultFoodAsset",
  description: "Create a new food inventory account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "FoodInventory",
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
}
|> Procedures.create_procedure()

{:ok, supplies_asset} = %{
  name: "DefaultSuppliesAsset",
  description: "Create a new supplies inventory account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "SuppliesInventory",
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
}
|> Procedures.create_procedure()

### expense account prcedures ###

{:ok, wage_expenses} = %{
  name: "DefaultWageExpense",
  description: "Create a new wages expense account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "Wages",
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
      value: "expense",
      type: "default"
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
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "OtherExpense",
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
      value: "expense",
      type: "default"
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
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "EquipmentVendor",
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
      value: "liability",
      type: "default"
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
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "FoodVendor",
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
      value: "liability",
      type: "default"
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
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "Grosslabor",
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
      value: "liability",
      type: "default"
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
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "SalesTax",
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
      value: "liability",
      type: "default"
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
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "SupplyVendor",
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
      value: "liability",
      type: "default"
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
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "CashSales",
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
      value: "revenue",
      type: "default"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, credit_card_revenue} = %{
  name: "DefaultCreditCardSalesRevenue",
  description: "Create a new credit card revenue account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  params: [
    %{
      name: "currency", 
      value: "currency",
      type: "inputs"
    },
    %{
      name: "name", 
      value: "CreditCardSales",
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
      value: "revenue",
      type: "default"
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
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "credit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, credit_cash_sales} = %{
  name: "CreditCashSales",
  description: "credit the revenue cash account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "credit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, credit_credit_card_sales} = %{
  name: "CreditCreditCardSales",
  description: "credit the revenue credit card account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "credit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, credit_food_vendor} = %{
  name: "CreditFoodVendor",
  description: "credit the food vendor liability account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    }
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "credit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, credit_gross_labor} = %{
  name: "CreditGrosslabor",
  description: "credit the gross labor liability account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },    
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "credit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, credit_sales_tax} = %{
  name: "CreditSalesTax",
  description: "credit the sales tax liability account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    }    
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "credit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, credit_supply_vendor} = %{
  name: "CreditSupplyVendor",
  description: "credit the supply vendor liability account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "credit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
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
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },    
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "debit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
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
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },   
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "debit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    },
  ]
}
|> Procedures.create_procedure()

{:ok, debit_food_inventory_account} = %{
  name: "DebitFoodInventory",
  description: "Debit the asset food inventory account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "debit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, debit_supplies_inventory} = %{
  name: "DebitSuppliesInventory",
  description: "Debit the asset supplies inventory account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },  
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "debit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()

{:ok, debit_wages} = %{
  name: "DebitWages",
  description: "Debit the wages account",
  type: "Transaction",
  action: "build",
  organization_id: organization.id,
  params: [
    %{
      name: "amount_subunits",
      value: "amount_subunits",
      type: "inputs"
    },
    %{
      name: "date",
      value: "date",
      type: "inputs"
    },
    %{
      name: "kind", 
      value: "debit",
      type: "default"
    },
    %{
      name: "object_uid", 
      value: "object_uid",
      type: "inputs"
    }
  ]
}
|> Procedures.create_procedure()


   