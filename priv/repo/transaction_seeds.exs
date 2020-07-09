#     mix run priv/repo/transaction_seeds.exs
import Ecto.Query, warn: false

alias HayaiLedger.Accounts
alias HayaiLedger.Accounts.Account
alias HayaiLedger.Ledgers
alias HayaiLedger.Organizations
alias HayaiLedger.Organizations.{Organization, User}
alias HayaiLedger.Repo

defmodule DateHelper do
	def format(num) when num < 10, do: "0#{num}"
	def format(num), do: "#{num}"
end

user_attrs = %{ 
	"email" => "erin@lender.com", 
	"first_name" => "erin", 
	"last_name" => "boeger", 
	"password" => "Password", 
	"password_confirmation" => "Password"
}
{:ok, user} = case Organizations.get_by_email(user_attrs["email"]) do
					nil -> Organizations.create_user(user_attrs)
					%User{} = found -> {:ok, found}
				end

organization_attrs = %{
	"description" => "A fintech company that lends money or handles loans and payment transactions", 
	"name" => "Lending Startup"
}
{:ok, organization} = case Repo.get_by(Organization, name: organization_attrs["name"]) do
								nil -> Organizations.create_organization(organization_attrs, user.id)
								%Organization{} = found -> {:ok, found}
							end

cash_account_attrs = %{
	"currency" => "JPY",
  "name" => "Cash",
  "object_type" => "CashAccount",
  "object_uid" => Base.encode64(:crypto.strong_rand_bytes(12)),
	"type" => "asset",
  "organization_id" => organization.id,
}
{:ok, cash_account} = case Repo.one(from a in Account, 
												where: a.name == ^cash_account_attrs["name"],
												where: a.object_type == ^cash_account_attrs["object_type"], 
												where: a.organization_id == ^organization.id) 
											do
												nil -> Accounts.create_account(cash_account_attrs, organization.id)
												%Account{} = found -> {:ok, found}
											end

for _ <- 1..10 do
	loan_account_attrs = %{
		"currency" => "JPY",
	  "name" => "Loan #{:rand.uniform(1000)}",
	  "object_type" => "LoanAccount",
	  "object_uid" => Base.encode64(:crypto.strong_rand_bytes(12)),
		"type" => "asset",
	  "organization_id" => organization.id,
	}
	{:ok, loan_account} = Accounts.create_account(loan_account_attrs, organization.id)

	borrower_account_attrs = %{
		"currency" => "JPY",
	  "name" => "Borrower #{:rand.uniform(1000)}",
	  "object_type" => "PaymentAccount",
	  "object_uid" => Base.encode64(:crypto.strong_rand_bytes(12)),
		"type" => "liability",
	  "organization_id" => organization.id,
	}
	{:ok, borrower_account} = Accounts.create_account(borrower_account_attrs, organization.id)

	loan = :rand.uniform(300_000_00)

	loan_disbursement = [
		Ledgers.build_transaction(%{
			"account_uid" => cash_account.uid,
			"amount_currency" => "JPY", 
			"amount_subunits" => loan,
			"date" => "2015-01-01T00:00:01Z",
			"description" => "lender.disburse.borrower",
			"kind" => "credit"
		}),
		Ledgers.build_transaction(%{
			"account_uid" => borrower_account.uid,
			"amount_currency" => "JPY", 
			"amount_subunits" => loan,
			"date" => "2015-01-01T00:00:01Z",
			"description" => "principle.disburse.borrower",
			"kind" => "debit"
		})
	]

	%{
		"description" => "borrower payment to lender",
		"object_type" => "LoanPayment",
		"object_uid" => Base.encode64(:crypto.strong_rand_bytes(12)),
		"organization_id" => organization.id
	}
	|> Ledgers.journal_entry(loan_disbursement)

	payment = div(loan, 360)
	principle = div(payment, 100)
	start = 2014 + :rand.uniform(5)
	for year <- start..2019 do
		for month <- 1..12 do
			principle = principle + month
			interest = payment - principle
			day = :rand.uniform(9)
			transactions = [
				Ledgers.build_transaction(%{
					"account_uid" => borrower_account.uid,
					"amount_currency" => "JPY", 
					"amount_subunits" => payment,
					"date" => "#{year}-#{DateHelper.format(month)}-#{DateHelper.format(day)}T00:00:01Z",
					"description" => "borrower.payment.lender",
					"kind" => "credit"
				}),
				Ledgers.build_transaction(%{
					"account_uid" => cash_account.uid,
					"amount_currency" => "JPY", 
					"amount_subunits" => interest,
					"date" => "#{year}-#{DateHelper.format(month)}-#{DateHelper.format(day)}T00:00:01Z",
					"description" => "interest.payment.lender",
					"kind" => "debit"
				}),
				Ledgers.build_transaction(%{
					"account_uid" => loan_account.uid,
					"amount_currency" => "JPY", 
					"amount_subunits" => principle,
					"date" => "#{year}-#{DateHelper.format(month)}-#{DateHelper.format(day)}T00:00:01Z",
					"description" => "principle.payment.lender",
					"kind" => "debit"
				})
			]

			%{
				"description" => "borrower payment to lender",
				"object_type" => "LoanPayment",
				"object_uid" => Base.encode64(:crypto.strong_rand_bytes(12)),
				"organization_id" => organization.id
			}
			|> Ledgers.journal_entry(transactions)
		end
	end

	today = Date.utc_today()
	for month <- 1..today.month do
		principle = principle + month
		interest = payment - principle
		day = :rand.uniform(9)
		
		transactions = [
			Ledgers.build_transaction(%{
				"account_uid" => borrower_account.uid,
				"amount_currency" => "JPY", 
				"amount_subunits" => payment,
				"date" => "2020-#{DateHelper.format(month)}-#{DateHelper.format(day)}T00:00:01Z",
				"description" => "borrower.payment.lender",
				"kind" => "credit"
			}),
			Ledgers.build_transaction(%{
				"account_uid" => cash_account.uid,
				"amount_currency" => "JPY", 
				"amount_subunits" => interest,
				"date" => "2020-#{DateHelper.format(month)}-#{DateHelper.format(day)}T00:00:01Z",
				"description" => "interest.payment.lender",
				"kind" => "debit"
			}),
			Ledgers.build_transaction(%{
				"account_uid" => loan_account.uid,
				"amount_currency" => "JPY", 
				"amount_subunits" => principle,
				"date" => "2020-#{DateHelper.format(month)}-#{DateHelper.format(day)}T00:00:01Z",
				"description" => "principle.payment.lender",
				"kind" => "debit"
			})
		]

		%{
			"description" => "borrower payment to lender",
			"object_type" => "LoanPayment",
			"object_uid" => Base.encode64(:crypto.strong_rand_bytes(12)),
			"organization_id" => organization.id
		}
		|> Ledgers.journal_entry(transactions)
		
	end
end
