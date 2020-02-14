defmodule HayaiLedger.Ledgers.BalanceTest do
	use HayaiLedger.DataCase

	import Support.Fixtures.AccountFixtures

	alias HayaiLedger.Accounts.Balance

	describe "validations" do
		test "returns error if no amount_currency" do
			no_currency = Map.delete(balance_attrs(), :amount_currency)
			balance = Balance.changeset(%Balance{}, no_currency)
			assert false == balance.valid?
      assert  {"can't be blank", [validation: :required]} == balance.errors[:amount_currency]
		end

		test "returns error if currency does not match account" do
			bad_currency = Map.put(balance_attrs(), :amount_currency, "NOM")
			balance = Balance.changeset(%Balance{}, bad_currency)
			assert false == balance.valid?
      assert  {"currency must match accounts currency", [validation: :required]} == balance.errors[:amount_currency]
		end

		test "returns error if no amount_subunits" do
			no_subunits = Map.delete(balance_attrs(), :amount_subunits)
			balance = Balance.changeset(%Balance{}, no_subunits)
			assert false == balance.valid?
      assert  {"can't be blank", [validation: :required]} == balance.errors[:amount_subunits]
		end

		test "returns error if no account_id" do
			no_account = Map.delete(balance_attrs(), :account_id)
			balance = Balance.changeset(%Balance{}, no_account)
			assert false == balance.valid?
      assert  {"can't be blank", [validation: :required]} == balance.errors[:account_id]
		end

		test "returns a valid changeset if all validations pass" do
			balance = Balance.changeset(%Balance{}, balance_attrs())
			assert balance.valid?
		end
	end
end
