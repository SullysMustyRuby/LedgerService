defmodule HayaiLedgerWeb.Schema.Queries.TransactionQueries do
	use Absinthe.Schema.Notation

	alias HayaiLedgerWeb.Schema.Resolvers.TransactionResolver

	object :transaction_queries do
		
		field :all_transactions, list_of(:transaction) do
			arg :amount_currency, :string
			arg :amount_subunits, :integer
			arg :date, :datetime
			arg :kind, :string
			arg :from_date, :datetime
			arg :to_date, :datetime
			arg :limit, :integer
			arg :offset, :integer
			
			resolve &TransactionResolver.all_transactions/3
		end

		@desc "Get a single transaction"
		field :transaction, :transaction do
			arg :uid, non_null(:string)

			resolve &TransactionResolver.find_transaction/3
		end


		# field :transactions_by_account_name, list_of(:transaction) do
		# 	arg :name, non_null(:string)
		# 	arg :object_uid, :string
		# 	arg :from_date, :datetime
		# 	arg :to_date, :datetime
		# 	resolve &TransactionResolver.transactions_by_account_name/3
		# end

		# field :transactions_sum, :total do
		# 	arg :name, non_null(:string)
		# 	arg :object_uid, non_null(:string)
		# 	resolve &TransactionResolver.transactions_sum/3
		# end
	end
end
