defmodule HayaiLedger.Ledgers.BalanceTest do
  use HayaiLedger.DataCase

   alias HayaiLedger.Ledgers.Balance

	describe "validations" do
		test "returns error if no amount_currency" do
			no_currency = Map.delete(valid_attrs(), :amount_currency)
			balance = Balance.changeset(%Balance{}, no_currency)
			assert false == balance.valid?
      assert  {"can't be blank", [validation: :required]} == balance.errors[:amount_currency]
		end

		test "returns error if currency does not match account" do
			bad_currency = Map.put(valid_attrs(), :amount_currency, "JPY")
			balance = Balance.changeset(%Balance{}, bad_currency)
			assert false == balance.valid?
      assert  {"currency must match accounts currency", [validation: :required]} == balance.errors[:amount_currency]
		end

		test "returns error if no amount_subunits" do
			no_subunits = Map.delete(valid_attrs(), :amount_subunits)
			balance = Balance.changeset(%Balance{}, no_subunits)
			assert false == balance.valid?
      assert  {"can't be blank", [validation: :required]} == balance.errors[:amount_subunits]
		end

		test "returns error if no account_id" do
			no_account = Map.delete(valid_attrs(), :account_id)
			balance = Balance.changeset(%Balance{}, no_account)
			assert false == balance.valid?
      assert  {"can't be blank", [validation: :required]} == balance.errors[:account_id]
		end

		test "returns a valid changeset if all validations pass" do
			balance = Balance.changeset(%Balance{}, valid_attrs())
			assert balance.valid?
		end
	end

	defp valid_attrs() do
		%{ 
			account_id: create_account().id,
			amount_currency: "THB", 
			amount_subunits: 0, 
		}
	end

  defp create_account() do
    {:ok, account} = HayaiLedger.Accounts.create_account(%{
                        currency: "THB",
                        kind: "asset",
                        name: "Lex Cash",
                        type_id: create_account_type().id
                      })
    account
  end

  defp create_account_type() do
    {:ok, type} = HayaiLedger.Accounts.create_account_type(%{ name: "cash" })
    type
  end
end