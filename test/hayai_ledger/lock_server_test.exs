defmodule HayaiLedger.LockServerTest do
  use HayaiLedger.DataCase

	alias HayaiLedger.Accounts
	alias HayaiLedger.Ledgers
  alias HayaiLedger.LockServer

  describe "await/2" do
  	setup do
  		{:ok, account} = create_account()
  		Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "credit" }))
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "debit" }))
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "credit" }))
      %{
      	account: account
      }
  	end

  	test "returns timeout if account does not unlock in time", %{ account: account } do
      LockServer.lock(account.uid)
      assert {:error, "account lock timeout"} == LockServer.await(account.uid, {Ledgers, :sum_credits_and_debits_for_account, [account.id]})
  	end

  	test "returns method results if account is not locked", %{ account: account } do
      assert 1000 == LockServer.await(account.uid, {Ledgers, :sum_credits_and_debits_for_account, [account.id]})
  	end

  	test "returns method results if account is locked, and unlocked in time", %{ account: account } do
      LockServer.lock(account.uid)
      Task.start(fn -> sleep_unlock(account.uid, 500) end)
      assert 1000 == LockServer.await(account.uid, {Ledgers, :sum_credits_and_debits_for_account, [account.id]})
    end

    test "timeout is adjustable", %{ account: account} do
    	LockServer.lock(account.uid)
    	Task.start(fn -> sleep_unlock(account.uid, 100) end)
    	assert 1000 == LockServer.await(account.uid, {Ledgers, :sum_credits_and_debits_for_account, [account.id]}, 110)
    end
  end

	describe "lock/1" do
		test "stores the uid and the pid of the caller" do
			{:ok, account} = create_account()
			assert account.uid == LockServer.lock(account.uid)
			assert [{account.uid, self()}] == :ets.lookup(:account_locks, account.uid)
		end

		test "returns error if account uid does not exist" do
			assert {:error, "account does not exist"} == LockServer.lock("555")
		end

		test "Does not save multiple locks" do
			{:ok, account} = create_account()
			assert account.uid == LockServer.lock(account.uid)
			assert [{account.uid, self()}] == :ets.lookup(:account_locks, account.uid)
			assert account.uid == LockServer.lock(account.uid)
			assert LockServer.unlock(account.uid)
			assert [] == :ets.lookup(:account_locks, account.uid)
		end
	end

	describe "locked?/1" do
		test "returns true if account has been locked" do
			{:ok, account} = create_account()
			assert account.uid == LockServer.lock(account.uid)
			assert LockServer.locked?(account.uid)
		end

		test "returns false if account is not locked" do
			{:ok, account} = create_account()
			assert false == LockServer.locked?(account.uid)
		end

		test "returns false if account does not exist" do
			assert false == LockServer.locked?(555)
		end
	end

	describe "unlock/1" do
		test "it returns true if the account has been unlocked" do
			{:ok, account} = create_account()
			assert account.uid == LockServer.lock(account.uid)
			assert LockServer.locked?(account.uid)
			assert LockServer.unlock(account.uid)
			assert false == LockServer.locked?(account.uid) 
		end

		test "it returns true if the account was not locked" do
			assert LockServer.unlock(555)
		end
	end

  defp create_account_type() do
    {:ok, type} = HayaiLedger.Accounts.create_account_type(%{ name: "cash" })
    type
  end

	defp create_account() do
    Accounts.create_account(%{
      currency: "JPY",
      meta_data: %{}, 
      name: "some name", 
      object_type: "some object_type", 
      object_uid: "some object_uid",
      type_id: create_account_type().id, 
      uid: "some uid"
    })
  end

  defp sleep_unlock(account_uid, milisec) do
  	:timer.sleep(milisec)
  	LockServer.unlock(account_uid)
  end

  defp valid_transaction_attrs(attrs) do
    Enum.into(attrs, %{
      amount_currency: "JPY", 
      amount_subunits: 42, 
      kind: "credit"
    })
  end
end