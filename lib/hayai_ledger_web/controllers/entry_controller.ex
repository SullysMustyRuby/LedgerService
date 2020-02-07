defmodule HayaiLedgerWeb.EntryController do
  use HayaiLedgerWeb, :controller

  def create(conn, %{ "journal_entry" => journal_entry }) do
  	require IEx; IEx.pry
  end
end
# {
#   "journal_entry":
#   {
#     "options":
#     {
#       "balance_verify": {
#         "account": "account_uid",
#         "minimum": "1000" or "non_negative"
#       }
#     }
#     "entry": 
#     {
#       "description": "product purchase",
#       "object_type": "Sale",
#       "object_uid": "sale_id"
#     }
#     "credits": 
#     [
#       {
#         "account_uid": "uid_company",
#         "amount_subunits": 1000,
#         "description": "product purchase balance",
#         "type": "type_uid"
#       },
#       {
#         "account_uid": "uid_company_tax",
#         "amount_subunits": 150,
#         "description": "product purchase tax",
#         "type": "type_uid"
#       }
#     ],
#     "debits": 
#     [
#       {
#         "account_uid": "uid_customer",
#         "amount_subunits": 1150
#         "description": "product purchase",
#         "type": "type_uid"
#       }
#     ]
#   }
# }