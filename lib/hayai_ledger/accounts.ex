defmodule HayaiLedger.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias HayaiLedger.Repo
  alias HayaiLedger.Accounts.{Balance, Account, AccountType}
  alias HayaiLedger.Ledgers
  alias HayaiLedger.Procedures.Procedure

  def active_accounts_exist?(%{ name: name, object_uid: object_uid }) do
    Repo.exists?(from a in Account,
      where: a.name == ^name,
      where: a.object_uid == ^object_uid,
      where: a.active == true
      )
  end

  def active_accounts_exist?(%{ name: name, organization_id: organization_id }) do
    Repo.exists?(from a in Account,
      where: a.name == ^name,
      where: a.organization_id == ^organization_id,
      where: a.active == true
      )
  end

  def balance_amount_subunits_for_account(account_id) do
    Repo.one(from b in Balance,
    where: b.account_id == ^account_id,
    select: b.amount_subunits)
  end

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
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    with {:ok, account} <- insert_account(attrs),
      {:ok, _balance} <- insert_balance(account)
    do
      {:ok, account}
    end
  end

  def create_account(attrs, organization_id) do
    with {:ok, account} <- insert_account(attrs, organization_id),
      {:ok, _balance} <- insert_balance(account)
    do
      {:ok, account}
    end
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
  Gets a single balance.

  Raises `Ecto.NoResultsError` if the Balance does not exist.

  ## Examples

      iex> get_balance!(123)
      %Balance{}

      iex> get_balance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_balance!(id), do: Repo.get!(Balance, id)

  def get_balance_by_account(account_id) do
    Repo.get_by(Balance, account_id: account_id)
  end

  def handle_procedure(%Procedure{ action: "create", params: params }, inputs, organization_id) do
    Account.apply_params(params, inputs, organization_id)
    |> create_account()
  end

  def handle_procedure(_procedure, _inputs, _organization_id), do: {:error, "no procedure for that action"}

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  def list_accounts(organization_id) do
    Repo.all(from a in Account,
      where: a.organization_id == ^organization_id,
      select: a)
  end

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

  @doc """
  Updates a balance.

  ## Examples

  """
  def update_balance(account_id, amount_subunits) do
    with %Balance{} = balance <- get_balance_by_account(account_id) do
      Balance.changeset(balance, %{ amount_subunits: amount_subunits })
      |> Repo.update()
    end
  end
  
  defp insert_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  defp insert_account(attrs, organization_id) do
    Map.put(attrs, "organization_id", organization_id)
    |> insert_account()
  end

  defp insert_balance(%{ id: account_id, currency: currency }) do
    create_balance(%{ account_id: account_id, amount_currency: currency, amount_subunits: 0 })
  end
end
