defmodule HayaiLedgerWeb.Schema.Queries.AccountQueries do
	use Absinthe.Schema.Notation

	alias HayaiLedgerWeb.Schema.Resolvers.AccountResolver

	object :account_queries do

		@desc "Get all accounts for your organization"
		field :all_accounts, list_of(:account) do
			arg :active, :boolean
			arg :currency, :string
			arg :name, :string
			arg :object_type, :string
			arg :object_uid, :string
			arg :uid, :string
			arg :type, :string
			arg :from_date, :datetime
			arg :to_date, :datetime
			arg :limit, :integer
			arg :offset, :integer
			
			resolve &AccountResolver.all_accounts/3
		end

		@desc "Get a single account"
		field :account, :account do
			arg :uid, non_null(:string)

			resolve &AccountResolver.find_account/3
		end
	end
end
