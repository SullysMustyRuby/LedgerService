defmodule HayaiLedger.Ledgers do
  @moduledoc """
  The Ledgers context.
  """

  import Ecto.Query, warn: false

  alias HayaiLedger.Ledgers.{Entry, Transaction}
  alias HayaiLedger.Repo

  def build_transaction(attrs \\ %{}) do
    %Transaction{}
      |> Transaction.changeset(attrs)
  end

  @doc """
  Creates a transactionless entry.

  ## Examples

      iex> create_empty_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_empty_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_empty_entry(attrs \\ %{}) do
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

  #  think best not to be able to delete an entry
  # @doc """
  # Deletes a Entry.

  # ## Examples

  #     iex> delete_entry(entry)
  #     {:ok, %Entry{}}

  #     iex> delete_entry(entry)
  #     {:error, %Ecto.Changeset{}}

  # """
  # def delete_entry(%Entry{} = entry) do
  #   Repo.delete(entry)
  # end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking entry changes.

  # ## Examples

  #     iex> change_entry(entry)
  #     %Ecto.Changeset{source: %Entry{}}

  # """
  # def change_entry(%Entry{} = entry) do
  #   Entry.changeset(entry, %{})
  # end


  # @doc """
  # Updates a transaction.

  # ## Examples

  #     iex> update_transaction(transaction, %{field: new_value})
  #     {:ok, %Transaction{}}

  #     iex> update_transaction(transaction, %{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def update_transaction(%Transaction{} = transaction, attrs) do
  #   transaction
  #   |> Transaction.changeset(attrs)
  #   |> Repo.update()
  # end

  # @doc """
  # Deletes a Transaction.

  # ## Examples

  #     iex> delete_transaction(transaction)
  #     {:ok, %Transaction{}}

  #     iex> delete_transaction(transaction)
  #     {:error, %Ecto.Changeset{}}

  # """
  # def delete_transaction(%Transaction{} = transaction) do
  #   Repo.delete(transaction)
  # end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  # ## Examples

  #     iex> change_transaction(transaction)
  #     %Ecto.Changeset{source: %Transaction{}}

  # """
  # def change_transaction(%Transaction{} = transaction) do
  #   Transaction.changeset(transaction, %{})
  # end

  # defp create_transactions_with_entry([], _id), do: :ok

  # defp create_transactions_with_entry([head | tail], id) do
  #   with transaction when is_map(transaction) <- Map.put(head, :entry_id, id),
  #     {:ok, _new_transaction} <- create_transaction(transaction)
  #   do
  #     create_transactions_with_entry(tail, id)
  #   else
  #     _ -> :error
  #   end
  # end

  # def async_validate_transactions(transactions) do
  #   with :ok <- async_validate_accounts(transactions),
  #     :ok <- validate_transaction_amount(transactions),
  #     :ok <- async_validate_transaction_currency(transactions)
  #   do
  #     :ok
  #   else
  #     {:error, message} -> {:error, message}
  #   end
  # end


  # defp async_validate_accounts(transactions) do
  #   if length(transactions) <= 1, do: {:error, "must include transactions that balance"}
  #   Task.async_stream(transactions, &validate_account/1)
  #     |> Enum.all?(fn(_task) -> {:ok, nil} end)
  # end

  # defp validate_account(%{ account_id: account_id }) do
  #   Repo.exists?(from a in Account, where: a.id == ^account_id)
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
  # end

  # defp validate_transaction_amount(transactions, total_credits \\ 0, total_debits \\ 0)

  # defp validate_transaction_amount([], 0, 0), do: {:error, "there are no credits or debits"}

  # defp validate_transaction_amount([], total_credits, total_debits) do
  #   case total_credits - total_debits do
  #     0 -> :ok
  #     _ -> {:error, "credits and debits do not balance"}
  #   end
  # end

  # defp validate_transaction_amount([%{ type: "credit", amount_subunits: amount} | tail], total_credits, total_debits) do
  #   validate_transaction_amount(tail, (total_credits + amount), total_debits)
  # end

  # defp validate_transaction_amount([%{ type: "debit", amount_subunits: amount} | tail], total_credits, total_debits) do
  #   validate_transaction_amount(tail, total_credits, (total_debits + amount))
  # end
