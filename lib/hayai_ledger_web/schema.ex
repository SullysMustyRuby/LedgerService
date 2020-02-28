defmodule HayaiLedgerWeb.Schema do
	use Absinthe.Schema

	import_types Absinthe.Type.Custom

	import_types HayaiLedgerWeb.Schema.Mutations.ProcedureMutations

	import_types HayaiLedgerWeb.Schema.Queries.AccountQueries
	import_types HayaiLedgerWeb.Schema.Queries.EntryQueries
	import_types HayaiLedgerWeb.Schema.Queries.ProcedureQueries
	import_types HayaiLedgerWeb.Schema.Queries.TransactionQueries

	import_types HayaiLedgerWeb.Schema.Types.Accounts
	import_types HayaiLedgerWeb.Schema.Types.Entries
	import_types HayaiLedgerWeb.Schema.Types.Procedures
	import_types HayaiLedgerWeb.Schema.Types.Transactions

	query do

		import_fields :account_queries
		import_fields :entry_queries
		import_fields :procedure_queries
		import_fields :transaction_queries

	end

	mutation do
		
		import_fields :procedure_mutations

	end

end
