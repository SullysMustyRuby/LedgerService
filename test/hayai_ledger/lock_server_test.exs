defmodule HayaiLedger.LockServerTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.AccountFixtures, only: [{:account_fixture, 0}]
  import Support.Fixtures.LedgerFixtures, only: [{:transaction_fixture, 1}]

	alias HayaiLedger.Ledgers
  alias HayaiLedger.LockServer

  describe "await/2" do
  	setup do
  		account = account_fixture()
  		transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "credit" })
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "debit" })
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "credit" })
      %{
      	account: account
      }
  	end

  	test "returns timeout if account does not unlock in time", %{ account: account } do
      LockServer.account_lock(account.uid)
      assert {:error, "account lock timeout"} == LockServer.await(account.uid, {Ledgers, :transactions_sum_by_account, [account.id]})
  	end

  	test "returns method results if account is not locked", %{ account: account } do
      assert 1000 == LockServer.await(account.uid, {Ledgers, :transactions_sum_by_account, [account.id]})
  	end

  	test "returns method results if account is locked, and unlocked in time", %{ account: account } do
      LockServer.account_lock(account.uid)
      Task.start(fn -> sleep_unlock(account.uid, 500) end)
      assert 1000 == LockServer.await(account.uid, {Ledgers, :transactions_sum_by_account, [account.id]})
    end

    test "timeout is adjustable", %{ account: account} do
    	LockServer.account_lock(account.uid)
    	Task.start(fn -> sleep_unlock(account.uid, 100) end)
    	assert 1000 == LockServer.await(account.uid, {Ledgers, :transactions_sum_by_account, [account.id]}, 110)
    end
  end

	describe "account_lock/1" do
    setup do
      %{
        account: account_fixture()
      }
    end

		test "stores the uid and the pid of the caller", %{ account: account } do
			assert account.uid == LockServer.account_lock(account.uid)
			assert [{account.uid, self()}] == :ets.lookup(:account_locks, account.uid)
		end

		test "returns error if account uid does not exist" do
			assert {:error, "account does not exist"} == LockServer.account_lock("555")
		end

		test "Does not save multiple locks", %{ account: account } do
			assert account.uid == LockServer.account_lock(account.uid)
			assert {:error, "account lock timeout"} == LockServer.account_lock(account.uid)
			assert LockServer.account_unlock(account.uid)
			assert [] == :ets.lookup(:account_locks, account.uid)
		end
	end

	describe "account_locked?/1" do
    setup do
      %{
        account: account_fixture()
      }
    end

		test "returns true if account has been locked", %{ account: account } do
			assert account.uid == LockServer.account_lock(account.uid)
			assert LockServer.account_locked?(account.uid)
		end

		test "returns false if account is not locked", %{ account: account } do
			assert false == LockServer.account_locked?(account.uid)
		end

		test "returns false if account does not exist" do
			assert false == LockServer.account_locked?(555)
		end
	end

	describe "account_unlock/1" do
		test "it returns true if the account has been unlocked" do
			account = account_fixture()
			assert account.uid == LockServer.account_lock(account.uid)
			assert LockServer.account_locked?(account.uid)
			assert LockServer.account_unlock(account.uid)
			assert false == LockServer.account_locked?(account.uid) 
		end

		test "it returns true if the account was not locked" do
			assert LockServer.account_unlock(555)
		end
	end

  defp sleep_unlock(account_uid, milisec) do
  	:timer.sleep(milisec)
  	LockServer.account_unlock(account_uid)
  end
end