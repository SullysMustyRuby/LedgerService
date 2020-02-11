defmodule HayaiLedger.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias HayaiLedger.Repo
  alias HayaiLedger.Accounts.{Account, AccountType}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account_type changes.

  ## Examples

      iex> change_account_type(account_type)
      %Ecto.Changeset{source: %AccountType{}}

  """
  def change_account_type(%AccountType{} = account_type) do
    AccountType.changeset(account_type, %{})
  end

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a account_type.

  ## Examples

      iex> create_account_type(%{field: value})
      {:ok, %AccountType{}}

      iex> create_account_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account_type(attrs \\ %{}) do
    %AccountType{}
    |> AccountType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  #  soft delete this
  # def delete_account(%Account{} = account) do
  #   Repo.delete(account)
  # end

  @doc """
  Deletes a AccountType.

  ## Examples

      iex> delete_account_type(account_type)
      {:ok, %AccountType{}}

      iex> delete_account_type(account_type)
      {:error, %Ecto.Changeset{}}

  """
  #  soft delete this
  # def delete_account_type(%AccountType{} = account_type) do
  #   Repo.delete(account_type)
  # end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  def get_account(id), do: Repo.get(Account, id)

  def get_account_by_uid!(uid) do
    Repo.get_by(Account, uid: uid)
      |> Repo.preload(:type)
  end

  def get_account_by_uid(uid) do
    case get_account_by_uid!(uid) do
      %Account{} = account -> {:ok, account}
      _ -> {:error, "account not found for uid: #{uid}"}
    end
  end

  def get_account_uid(nil), do: {:error, "no account id"}

  def get_account_uid(id) do
    Repo.one(from a in Account,
    where: a.id == ^id,
    select: a.uid)
  end

  @doc """
  Gets a single account_type.

  Raises `Ecto.NoResultsError` if the Account type does not exist.

  ## Examples

      iex> get_account_type!(123)
      %AccountType{}

      iex> get_account_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account_type!(id), do: Repo.get!(AccountType, id)

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Returns the list of account_types.

  ## Examples

      iex> list_account_types()
      [%AccountType{}, ...]

  """
  def list_account_types do
    Repo.all(AccountType)
  end

  @doc """
  Updates a account_type.

  ## Examples

      iex> update_account_type(account_type, %{field: new_value})
      {:ok, %AccountType{}}

      iex> update_account_type(account_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account_type(%AccountType{} = account_type, attrs) do
    account_type
    |> AccountType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end
end
