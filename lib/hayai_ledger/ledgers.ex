defmodule HayaiLedger.Ledgers do
  @moduledoc """
  The Ledgers context.
  """

  import Ecto.Multi
  import Ecto.Query, warn: false

  alias HayaiLedger.Ledgers.{Balance, Entry, Transaction}
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
  Creates a balance.

  ## Examples

      iex> create_balance(%{field: value})
      {:ok, %Balance{}}

      iex> create_balance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_balance(attrs \\ %{}) do
    %Balance{}
    |> Balance.changeset(attrs)
    |> Repo.insert()
  end

  def create_bookeeping_entry(_attrs, []), do: {:error, "must have transactions that balance"}

  def create_bookeeping_entry(attrs, transactions) do
    with :ok <- transactions_all_valid?(transactions),
      :ok <- validate_transactions_balance(transactions),
      %Ecto.Changeset{ valid?: true } = entry <- build_entry(attrs),
      {:ok, %{ entry: entry } } <- save_all(entry, transactions)
    do
      {:ok, entry}
    end
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
  Gets a single balance.

  Raises `Ecto.NoResultsError` if the Balance does not exist.

  ## Examples

      iex> get_balance!(123)
      %Balance{}

      iex> get_balance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_balance!(id), do: Repo.get!(Balance, id)

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

  @doc """
  Returns the list of balances.

  ## Examples

      iex> list_balances()
      [%Balance{}, ...]

  """
  def list_balances do
    Repo.all(Balance)
  end

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  def sum_credits_and_debits_for_account(account_id) do
    Repo.all(from t in Transaction,
      where: t.account_id == ^account_id,
      group_by: t.kind,
      select: {t.kind, sum(t.amount_subunits)}
    )
    |> sum_totals()
  end

  @doc """
  Updates a balance.

  ## Examples

      iex> update_balance(balance, %{field: new_value})
      {:ok, %Balance{}}

      iex> update_balance(balance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_balance(%Balance{} = balance, attrs) do
    balance
    |> Balance.changeset(attrs)
    |> Repo.update()
  end

  defp group_currencies(transactions) do
    Enum.group_by(transactions, fn(changeset) -> Ecto.Changeset.fetch_change!(changeset, :amount_currency) end)
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
    |> Ecto.Multi.insert_all(:transactions, Transaction, changesets)
  end

  defp save_all(entry_changeset, transactions) do
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

  defp transactions_all_valid?([]), do: :ok

  defp transactions_all_valid?([%Ecto.Changeset{ valid?: false } | _tail ]), do: {:error, "transactions must be valid"}

  defp transactions_all_valid?([%Ecto.Changeset{ valid?: true } | tail ]), do: transactions_all_valid?(tail)

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

  defp validate_amounts_balance(transactions, total_credits \\ 0, total_debits \\ 0)

  defp validate_amounts_balance([], total_credits, total_debits) do
    case total_credits - total_debits do
      0 -> :ok
      _ -> :error
    end
  end

  defp validate_amounts_balance([%Ecto.Changeset{ changes: %{ kind: "credit", amount_subunits: amount }, data: %HayaiLedger.Ledgers.Transaction{} } | tail], total_credits, total_debits) do
    validate_amounts_balance(tail, (total_credits + amount), total_debits)
  end

  defp validate_amounts_balance([%Ecto.Changeset{ changes: %{ kind: "debit", amount_subunits: amount }, data: %HayaiLedger.Ledgers.Transaction{} } | tail], total_credits, total_debits) do
    validate_amounts_balance(tail, total_credits, (total_debits + amount))
  end
end

  # need to build constraints on this and only allow safe mods
  # @doc """
  # Updates a entry.

  # ## Examples

  #     iex> update_entry(entry, %{field: new_value})
  #     {:ok, %Entry{}}

  #     iex> update_entry(entry, %{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def update_entry(%Entry{} = entry, attrs) do
  #   entry
  #   |> Entry.changeset(attrs)
  #   |> Repo.update()
  # end

  #   defp async_validate_transaction_currency([%{ amount_currency: currency } | _tail] = transactions) do
  #   try do
  #     Task.async_stream(transactions, fn transaction -> same_currency(transaction, currency) end)
  #     |> Enum.all?(fn task -> {:ok, nil} end)
  #     :ok
  #   rescue
  #     message -> {:error, message}
  #   end
  # end

  # defp same_currency(%{ amount_currency: currency }, default_currency) do
  #   if currency != default_currency do
  #     raise("currencies do not match")
  #   end
  # 

