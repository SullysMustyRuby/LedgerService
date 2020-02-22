defmodule HayaiLedger.Ledgers do
  @moduledoc """
  The Ledgers context.
  """
  import Ecto.Query, warn: false
  import HayaiLedger.LockServer
  import HayaiLedger.Helpers, only: [{:apply_params, 3}]

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.Account
  alias HayaiLedger.Ledgers.{Entry, Transaction}
  alias HayaiLedger.Procedures.Procedure
  alias HayaiLedger.Repo

  def build_entry(attrs \\ %{}) do
    %Entry{}
      |> Entry.changeset(attrs)
  end

  def build_transaction(attrs \\ %{}) do
    %Transaction{}
      |> Transaction.changeset(attrs)
  end

  @doc """
  Creates a transactionless entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
      |> Entry.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
      |> Transaction.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  def get_entry_with_transactions(id) do
    Repo.get!(Entry, id)
      |> Repo.preload(:transactions)
  end

  def get_entry_by_uid(uid) when is_binary(uid) do
    query = from e in Entry,
      where: e.uid == ^uid,
      preload: [:transactions]

    case Repo.one(query) do
      %Entry{} = entry -> {:ok, entry}
      _ -> {:error, "entry not found for uid: #{uid}"}
    end
  end

  def get_entry_by_uid(_), do: {:error, "entry not found"}

  def get_entry_uid(nil), do: {:error, "no entry id"}

  def get_entry_uid(id) do
    Repo.one(from e in Entry,
      where: e.id == ^id,
      select: e.uid)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def get_transaction_by_uid(uid) when is_binary(uid) do
    with %Transaction{} = transaction <- Repo.get_by(Transaction, uid: uid) do
     {:ok, transaction}
    else
      nil -> {:error, "transaction not found for uid: #{uid}"}
      {:error, message} -> {:error, message}
    end
  end

  def get_transaction_by_uid(_), do: {:error, "transaction not found"}

  def handle_entry_procedure(%Procedure{ action: "build", params: params }, inputs, organization_id) do
    entry = apply_params(params, inputs, organization_id)
            |> build_entry()
    case entry.valid? do
      true -> {:ok, entry}
      false -> {:error, entry.errors}
    end
  end

  def handle_entry_procedure(_procedure, _inputs, _organization_id), do: {:error, "no procedure for that action"}

  def handle_transaction_procedure(%Procedure{ action: "build", params: params }, inputs, organization_id) do
    transaction = apply_params(params, inputs, organization_id)
                  |> build_transaction()
    case transaction.valid? do
      true -> {:ok, transaction}
      false -> {:error, transaction.errors}
    end
  end

  def handle_transaction_procedure(_procedure, _inputs, _organization_id), do: {:error, "no procedure for that action"}

  def journal_entry(_attrs, []), do: {:error, "must have transactions that balance"}

  def journal_entry(%Ecto.Changeset{ valid?: true } = entry_changeset, transactions) do
    with :ok <- transactions_all_valid?(transactions),
      :ok <- validate_transactions_balance(transactions),
      {:ok, %{ entry: entry, transactions: {_, transactions} }} <- save_journal_entry(entry_changeset, transactions),
      :ok <- update_transaction_account_balances(transactions)
    do
      {:ok, entry, transactions}
    end
  end

  def journal_entry(entry_attrs, transactions) when is_map(entry_attrs) do
    build_entry(entry_attrs)
    |> journal_entry(transactions)
  end

  def journal_entry(_entry, _transactions), do: {:error, "journal entry failure"}

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
  end

  def list_entries(organization_id) do
    Repo.all(from e in Entry,
      where: e.organization_id == ^organization_id,
      select: e)
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions() do
    Repo.all(Transaction)
  end

  def list_transactions(organization_id) do
    Repo.all(from a in Account,
      where: a.organization_id == ^organization_id,
      join: t in Transaction,
      where: t.account_id == a.id,
      select: t)
  end

  def list_transactions_for_account(account_id) do
    Repo.all(from t in Transaction,
      where: t.account_id == ^account_id)
  end

  def safe_journal_entry(attrs, transactions, %{ account: account_uid } = check_options) do
    with :ok <- transactions_all_valid?(transactions),
      :ok <- balance_check(transactions, check_options),
      :ok <- validate_transactions_balance(transactions),
      false <- account_locked?(account_uid),
      account_uid <- account_lock(account_uid),
      %Ecto.Changeset{ valid?: true } = entry <- build_entry(attrs),
      {:ok, %{ entry: entry, transactions: {_, transactions} }} <- save_journal_entry(entry, transactions),
      :ok <- update_transaction_account_balances(transactions),
      true <- account_unlock(account_uid)
    do
      {:ok, entry, transactions}
    else
      true -> {:error, "account locked"}
      {:error, message} -> {:error, message}
    end
  end

  def transactions_sum_by_account(account_id) do
    Repo.all(from t in Transaction,
      where: t.account_id == ^account_id,
      group_by: t.kind,
      select: {t.kind, sum(t.amount_subunits)}
    )
    |> sum_totals()
  end

  defp balance_check(transactions, %{ account: account_uid, minimum: "non_negative" }) do
    balance_check(transactions, %{ account: account_uid, minimum: 0 })
  end

  defp balance_check(transactions, %{ account: account_uid, minimum: minimum }) when is_binary(minimum) do
    {int_min, _} = Integer.parse(minimum)
    balance_check(transactions, %{ account: account_uid, minimum: int_min })
  end

  defp balance_check(transactions, %{ account: account_uid, minimum: minimum }) when is_integer(minimum) do
    {balance_amount, transactions_amount} = Accounts.get_account_by_uid!(account_uid)
                                              |> balance_check_totals(transactions)
    case balance_amount + transactions_amount do
      total when total >= minimum -> :ok
      _ -> {:error, "transactions fail balance check"}
    end
  end

  defp balance_check_totals(%Account{ id: id }, transactions) do
    balance_amount = Task.async(fn -> transactions_sum_by_account(id) end)
    transactions_amount = Task.async(fn -> total_transactions(transactions, id) end)
    {Task.await(balance_amount), Task.await(transactions_amount)}
  end

  defp total_transactions(transactions, account_id) do
    Enum.filter(transactions, fn(transaction) -> Ecto.Changeset.fetch_change!(transaction, :account_id) == account_id end)
      |> total_credits_and_debits()
      |> sum_totals()
  end

  defp group_currencies(transactions) do
    Enum.group_by(transactions, fn(changeset) -> Ecto.Changeset.fetch_change!(changeset, :amount_currency) end)
  end

  defp group_by_account_kind(transactions) do
    Enum.group_by(transactions, fn(changeset) -> Ecto.Changeset.fetch_change!(changeset, :kind) end)
  end

  defp insert_all_transactions(transactions, entry) do
    changesets = Enum.map(transactions, fn %Ecto.Changeset{ changes: changes } -> Map.merge(changes, 
      %{ 
        entry_id: entry.id, 
        inserted_at: entry.inserted_at, 
        updated_at: entry.inserted_at 
        })
    end)
    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:transactions, Transaction, changesets, [returning: true])
  end

  defp save_journal_entry(entry_changeset, transactions) do
    try do
      Ecto.Multi.new()
        |> Ecto.Multi.insert(:entry, entry_changeset)
        |> Ecto.Multi.merge(fn %{ entry: entry } -> insert_all_transactions(transactions, entry) end)
        |> Repo.transaction()
    rescue
      Postgrex.Error -> {:error, "database error"}
    end
  end

  defp sum_totals([{"credit", credits}, {"debit", debits}]) when is_integer(credits) and is_integer(debits) do
    credits - debits
  end

  defp sum_totals([{"debit", debits}, {"credit", credits}]) when is_integer(credits) and is_integer(debits) do
    credits - debits
  end

  defp sum_totals([{"credit", credits}]), do: credits

  defp sum_totals([{"debit", debits}]), do: (0 - debits)

  defp sum_totals(_), do: 0

  defp total_credits_and_debits(transactions, total_credits \\ 0, total_debits \\ 0)

  defp total_credits_and_debits(nil, _total_credits, _total_debits), do: [{"credit", 0}, {"debit", 0}]

  defp total_credits_and_debits([], total_credits, total_debits), do: [{"credit", total_credits}, {"debit", total_debits}]

  defp total_credits_and_debits([%Ecto.Changeset{ changes: %{ kind: "credit", amount_subunits: amount }, data: %HayaiLedger.Ledgers.Transaction{} } | tail], total_credits, total_debits) do
    total_credits_and_debits(tail, (total_credits + amount), total_debits)
  end

  defp total_credits_and_debits([%Ecto.Changeset{ changes: %{ kind: "debit", amount_subunits: amount }, data: %HayaiLedger.Ledgers.Transaction{} } | tail], total_credits, total_debits) do
    total_credits_and_debits(tail, total_credits, (total_debits + amount))
  end

  defp transactions_all_valid?([]), do: :ok

  defp transactions_all_valid?([%Ecto.Changeset{ valid?: false } | _tail ]), do: {:error, "transactions must be valid"}

  defp transactions_all_valid?([%Ecto.Changeset{ valid?: true } | tail ]), do: transactions_all_valid?(tail)

  defp update_transaction_account_balances([]), do: :ok

  defp update_transaction_account_balances([%Transaction{ account_id: account_id } | tail]) do
    with amount when is_integer(amount) <- transactions_sum_by_account(account_id),
      {:ok, _} <- Accounts.update_balance(account_id, amount)
    do
      update_transaction_account_balances(tail)
    else
      nil -> {:error, "balance update error"}
    end
  end

  defp validate_amounts_balance(transactions) do
    with grouped <- group_by_account_kind(transactions),
      [{"credit", debit_kind_credits}, {"debit", debit_kind_debits}] <- total_credits_and_debits(grouped["debit"]),
      [{"credit", credit_kind_credits}, {"debit", credit_kind_debits}] <- total_credits_and_debits(grouped["credit"]),
      true <- (debit_kind_debits - debit_kind_credits) == (credit_kind_credits - credit_kind_debits)
    do
      :ok
    else
      {:error, message} -> {:error, message}
      false -> {:error, "transactions are not consistent"}
      _ -> {:error, "validate amounts balance failure"}
    end
  end

  defp validate_transactions_balance(transactions) when is_list(transactions) do 
    group_currencies(transactions)
    |> validate_transactions_balance()
  end

  defp validate_transactions_balance(transactions) when is_map(transactions) do
    case Enum.all?(transactions, fn({_key, changesets}) -> validate_amounts_balance(changesets) == :ok end) do
      true -> :ok
      _ -> {:error, "credits and debits do not balance"}
    end
  end
end
