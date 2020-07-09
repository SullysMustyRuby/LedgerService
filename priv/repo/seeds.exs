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
alias HayaiLedger.Organizations.{Organization, User}
alias HayaiLedger.Repo

user_attrs = %{ 
	"email" => "sullymustycode@gmail.com", 
	"first_name" => "erin", 
	"last_name" => "boeger", 
	"password" => "Password", 
	"password_confirmation" => "Password"
}

user = case Organizations.get_by_email(user_attrs["email"]) do
					nil -> Organizations.create_user(user_attrs)
					%User{} = found -> found
				end

organization_attrs = %{
	"description" => "The best ledger system perid!", 
	"name" => "HaiyaiLedger"
}

if Repo.get_by(Organization, name: organization_attrs["name"]) == nil do
	organization = Organizations.create_organization(organization_attrs)
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
end

# loans/credit cards
# 	accounts
# 	transactions
# 		loan disbursement
# 		loan payment 
# 			interest
# 			principle
# 		credit card
Cash account

loan 
	lender asset account (loan)
	borrower liability account (loan)

transactions
	payment -> loan
		interest
			credit interest(borrower)
			debit cash(lender) 
		principle
			credit liability(borrower)
			debit asset(lender)





