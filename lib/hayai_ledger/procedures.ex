defmodule HayaiLedger.Procedures do
  @moduledoc """
  The Procedures context.
  """

  import Ecto.Query, warn: false
  alias HayaiLedger.Repo

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.Account
  alias HayaiLedger.Ledgers
  alias HayaiLedger.Procedures.{Group, GroupProcedure, Param, Procedure}

  def process(%{ "name" => name, "inputs" => inputs }, organization_id) do
    with {:ok, procedure} <- get_procedure_by_name(name, organization_id) do
      process_procedure(procedure, inputs, organization_id)
    end
  end

  def process(%{ "entry" => entry_params, "transactions" => transaction_procedures }, organization_id) do
    with {:ok, entry} <- process(entry_params, organization_id),
      {:ok, transactions} = process_procedures(transaction_procedures, organization_id)
    do
      Ledgers.journal_entry(entry, transactions)
    end
  end

  def process(_params, _organization_id), do: {:error, "no process for that procedure"}

  def process_group(%{ "inputs" => inputs, "procedures" => procedures }, organization_id) do
    case async_process_group(inputs, procedures, organization_id) do
      [] -> {:ok, "all processed"}
      errors -> {:error, errors}
      _ -> {:error, "process group failed"}
    end
  end

  def process_group(%{ "name" => name, "inputs" => inputs }, organization_id) do
    with {:ok, group} <- get_group_by_name(name, organization_id) do
      case async_group_procedures(inputs, group.procedures, organization_id) do
        [] -> {:ok, "all processed"}
        errors -> {:error, errors}
        _ -> {:error, "process group failed"}
      end
    end
  end

  defp async_group_procedures(inputs, procedures, organization_id) do
    Task.async_stream(procedures, fn(procedure) -> process_procedure(procedure, inputs, organization_id) end)
    |> Enum.filter(fn({code, result}) -> code == :error  end)
  end
 
  defp async_process_group(inputs, procedures, organization_id) do
    Task.async_stream(procedures, fn(name) -> process(%{ "name" => name, "inputs" => inputs }, organization_id) end)
    |> Enum.filter(fn({code, result}) -> code == :error  end)
  end

  defp process_procedure(procedure, inputs, organization_id) do
    case procedure.type do
      "Account" -> Accounts.handle_account_procedure(procedure, inputs, organization_id)
      "Transaction" -> Ledgers.handle_transaction_procedure(procedure, inputs, organization_id)
      "Entry" -> Ledgers.handle_entry_procedure(procedure, inputs, organization_id)
    end
  end

  defp process_procedures(procedures, organization_id, processed \\ [])

  defp process_procedures([], _organization_id, processed), do: {:ok, processed}

  defp process_procedures([ procedure | tail ], organization_id, processed) do
    with {:ok, item} <- process(procedure, organization_id) do
      process_procedures(tail, organization_id, [ item | processed ])
    end
  end

  @doc """
  Returns the list of procedures.

  ## Examples

      iex> list_procedures()
      [%Procedure{}, ...]

  """
  def list_procedures do
    Repo.all(Procedure)
  end

  def list_procedures(organization_id) do
    Repo.all(from p in Procedure,
      where: p.organization_id == ^organization_id,
      select: p)
  end

  @doc """
  Gets a single procedure.

  Raises `Ecto.NoResultsError` if the Procedure does not exist.

  ## Examples

      iex> get_procedure!(123)
      %Procedure{}

      iex> get_procedure!(456)
      ** (Ecto.NoResultsError)

  """
  def get_procedure!(id) do
    Repo.get!(Procedure, id)
    |> Repo.preload(:params)
  end

  def get_procedure_by_name(name, organization_id) do
    case Repo.one(procedure_by_name_query(name, organization_id)) do
      %Procedure{} = procedure -> {:ok, procedure}
      _ -> {:error, "no process for that procedure"}
    end
  end

  defp procedure_by_name_query(name, organization_id) do
    from p in Procedure,
    where: p.name == ^name,
    where: p.organization_id == ^organization_id,
    select: p,
    preload: [:params]
  end

  def get_group_by_name(name, organization_id) do
    case Repo.one(group_by_name_query(name, organization_id)) do
      %Group{} = group -> {:ok, group}
      _ -> {:error, "no process for that group"}
    end
  end

  defp group_by_name_query(name, organization_id) do
    from g in Group,
    where: g.name == ^name,
    where: g.organization_id == ^organization_id,
    select: g,
    preload: [procedures: :params]
  end

  @doc """
  Creates a procedure.

  ## Examples

      iex> create_procedure(%{field: value})
      {:ok, %Procedure{}}

      iex> create_procedure(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_procedure(attrs \\ %{}) do
    %Procedure{}
    |> Procedure.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a procedure.

  ## Examples

      iex> update_procedure(procedure, %{field: new_value})
      {:ok, %Procedure{}}

      iex> update_procedure(procedure, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_procedure(%Procedure{} = procedure, attrs) do
    procedure
    |> Procedure.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a procedure.

  ## Examples

      iex> delete_procedure(procedure)
      {:ok, %Procedure{}}

      iex> delete_procedure(procedure)
      {:error, %Ecto.Changeset{}}

  """
  def delete_procedure(%Procedure{} = procedure) do
    Repo.delete(procedure)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking procedure changes.

  ## Examples

      iex> change_procedure(procedure)
      %Ecto.Changeset{source: %Procedure{}}

  """
  def change_procedure(%Procedure{} = procedure) do
    Procedure.changeset(procedure, %{})
  end

  @doc """
  Returns the list of params.

  ## Examples

      iex> list_params()
      [%Param{}, ...]

  """
  def list_params do
    Repo.all(Param)
  end

  @doc """
  Gets a single param.

  Raises `Ecto.NoResultsError` if the Type param does not exist.

  ## Examples

      iex> get_type_param!(123)
      %Param{}

      iex> get_type_param!(456)
      ** (Ecto.NoResultsError)

  """
  def get_param!(id), do: Repo.get!(Param, id)

  def get_param(id) do
    case Repo.get(Param, id) do
      nil -> {:error, "no param with that id"}
      param -> {:ok, param}
    end
  end

  @doc """
  Creates a param.

  ## Examples

      iex> create_param(%{field: value})
      {:ok, %Param{}}

      iex> create_param(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_param(attrs \\ %{}) do
    %Param{}
    |> Param.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a param.

  ## Examples

      iex> update_param(param, %{field: new_value})
      {:ok, %Param{}}

      iex> update_param(param, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_param(%Param{} = param, attrs) do
    param
    |> Param.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a param.

  ## Examples

      iex> delete_param(param)
      {:ok, %Param{}}

      iex> delete_param(param)
      {:error, %Ecto.Changeset{}}

  """
  def delete_param(%Param{} = param) do
    Repo.delete(param)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking param changes.

  ## Examples

      iex> change_param(param)
      %Ecto.Changeset{source: %Param{}}

  """
  def change_param(%Param{} = param) do
    Param.changeset(param, %{})
  end

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end

  @doc """
  Returns the list of group_procedures.

  ## Examples

      iex> list_group_procedures()
      [%GroupProcedure{}, ...]

  """
  def list_group_procedures do
    Repo.all(GroupProcedure)
  end

  @doc """
  Gets a single group_procedure.

  Raises `Ecto.NoResultsError` if the Group procedure does not exist.

  ## Examples

      iex> get_group_procedure!(123)
      %GroupProcedure{}

      iex> get_group_procedure!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_procedure!(id), do: Repo.get!(GroupProcedure, id)

  @doc """
  Creates a group_procedure.

  ## Examples

      iex> create_group_procedure(%{field: value})
      {:ok, %GroupProcedure{}}

      iex> create_group_procedure(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group_procedure(attrs \\ %{}) do
    %GroupProcedure{}
    |> GroupProcedure.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group_procedure.

  ## Examples

      iex> update_group_procedure(group_procedure, %{field: new_value})
      {:ok, %GroupProcedure{}}

      iex> update_group_procedure(group_procedure, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_procedure(%GroupProcedure{} = group_procedure, attrs) do
    group_procedure
    |> GroupProcedure.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group_procedure.

  ## Examples

      iex> delete_group_procedure(group_procedure)
      {:ok, %GroupProcedure{}}

      iex> delete_group_procedure(group_procedure)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group_procedure(%GroupProcedure{} = group_procedure) do
    Repo.delete(group_procedure)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_procedure changes.

  ## Examples

      iex> change_group_procedure(group_procedure)
      %Ecto.Changeset{source: %GroupProcedure{}}

  """
  def change_group_procedure(%GroupProcedure{} = group_procedure) do
    GroupProcedure.changeset(group_procedure, %{})
  end
end
