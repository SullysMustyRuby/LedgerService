defmodule HayaiLedger.LockServer do
  use GenServer
  @moduledoc """
  An in memory ets table used for storing account locking
  information

  """

  # Client
  @retry_sleep 10
  @await_timeout 1_000
  @table_name :account_locks

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def await(account_uid, {module, function_name, args}, timeout \\ @await_timeout) do
    case account_locked?(account_uid) do
      false -> apply(module, function_name, args)
      true -> retry_lock(account_uid, {module, function_name, args}, timeout)
    end
  end

  def account_lock(account_uid) do
    case HayaiLedger.Accounts.get_account_by_uid!(account_uid) do
      %HayaiLedger.Accounts.Account{} -> await(account_uid, {__MODULE__, :lock, [account_uid]})
      _ -> {:error, "account does not exist"}
    end
  end

  def account_locked?(account_uid) do
    case GenServer.call(__MODULE__, {:locked?, account_uid}) do
      true -> true
      false -> false
      _ -> {:error, "locked? check failure"}
    end
  end

  def account_unlock(account_uid) do
    case GenServer.call(__MODULE__, {:unlock, account_uid}) do
      true -> true
      false -> false
      _ -> {:error, "unlock failure"}
    end
  end

  def lock(account_uid) do
    GenServer.call(__MODULE__, {:lock, account_uid})
  end

  # Ets methods

  def init(_) do
    :ets.new(@table_name, [:named_table])
    {:ok, @table_name}
  end

  def handle_call({:lock, account_uid}, {pid, _reference}, state) do
    :ets.insert(@table_name, {account_uid, pid})
    {:reply, account_uid, state}
  end

  def handle_call({:locked?, account_uid}, _from, state) do
    member? = :ets.member(@table_name, account_uid)
    {:reply, member?, state}
  end

  def handle_call({:unlock, account_uid}, _from, state) do
    deleted? = :ets.delete(@table_name, account_uid)
    {:reply, deleted?, state}
  end

  defp retry_lock(account_uid, {module, function_name, args}, timeout) do
    task = Task.async(fn -> sleep_check(account_uid) end)
    case Task.yield(task, timeout) || Task.shutdown(task) do
      {:ok, :unlocked} -> apply(module, function_name, args)
      nil -> {:error, "account lock timeout"}
    end
  end

  defp sleep_check(account_uid) do
    case account_locked?(account_uid) do
      true -> :timer.sleep(@retry_sleep); sleep_check(account_uid)
      false -> :unlocked
    end
  end
end
