defmodule HayaiLedger.Procedures do
  @moduledoc """
  The Procedures context.
  """

  import Ecto.Query, warn: false
  alias HayaiLedger.Repo

  alias HayaiLedger.Procedures.ProcedureType

  @doc """
  Returns the list of procedure_types.

  ## Examples

      iex> list_procedure_types()
      [%ProcedureType{}, ...]

  """
  def list_procedure_types do
    Repo.all(ProcedureType)
  end

  @doc """
  Gets a single procedure_types.

  Raises `Ecto.NoResultsError` if the Procedure types does not exist.

  ## Examples

      iex> get_procedure_types!(123)
      %ProcedureType{}

      iex> get_procedure_types!(456)
      ** (Ecto.NoResultsError)

  """
  def get_procedure_types!(id), do: Repo.get!(ProcedureType, id)

  @doc """
  Creates a procedure_types.

  ## Examples

      iex> create_procedure_types(%{field: value})
      {:ok, %ProcedureType{}}

      iex> create_procedure_types(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_procedure_types(attrs \\ %{}) do
    %ProcedureType{}
    |> ProcedureType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a procedure_types.

  ## Examples

      iex> update_procedure_types(procedure_types, %{field: new_value})
      {:ok, %ProcedureType{}}

      iex> update_procedure_types(procedure_types, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_procedure_types(%ProcedureType{} = procedure_types, attrs) do
    procedure_types
    |> ProcedureType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a procedure_types.

  ## Examples

      iex> delete_procedure_types(procedure_types)
      {:ok, %ProcedureType{}}

      iex> delete_procedure_types(procedure_types)
      {:error, %Ecto.Changeset{}}

  """
  def delete_procedure_types(%ProcedureType{} = procedure_types) do
    Repo.delete(procedure_types)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking procedure_types changes.

  ## Examples

      iex> change_procedure_types(procedure_types)
      %Ecto.Changeset{source: %ProcedureType{}}

  """
  def change_procedure_types(%ProcedureType{} = procedure_types) do
    ProcedureType.changeset(procedure_types, %{})
  end

  alias HayaiLedger.Procedures.ProcedureAction

  @doc """
  Returns the list of procedure_actions.

  ## Examples

      iex> list_procedure_actions()
      [%ProcedureAction{}, ...]

  """
  def list_procedure_actions do
    Repo.all(ProcedureAction)
  end

  @doc """
  Gets a single procedure_actions.

  Raises `Ecto.NoResultsError` if the Procedure actions does not exist.

  ## Examples

      iex> get_procedure_actions!(123)
      %ProcedureAction{}

      iex> get_procedure_actions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_procedure_actions!(id), do: Repo.get!(ProcedureAction, id)

  @doc """
  Creates a procedure_actions.

  ## Examples

      iex> create_procedure_actions(%{field: value})
      {:ok, %ProcedureAction{}}

      iex> create_procedure_actions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_procedure_actions(attrs \\ %{}) do
    %ProcedureAction{}
    |> ProcedureAction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a procedure_actions.

  ## Examples

      iex> update_procedure_actions(procedure_actions, %{field: new_value})
      {:ok, %ProcedureAction{}}

      iex> update_procedure_actions(procedure_actions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_procedure_actions(%ProcedureAction{} = procedure_actions, attrs) do
    procedure_actions
    |> ProcedureAction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a procedure_actions.

  ## Examples

      iex> delete_procedure_actions(procedure_actions)
      {:ok, %ProcedureAction{}}

      iex> delete_procedure_actions(procedure_actions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_procedure_actions(%ProcedureAction{} = procedure_actions) do
    Repo.delete(procedure_actions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking procedure_actions changes.

  ## Examples

      iex> change_procedure_actions(procedure_actions)
      %Ecto.Changeset{source: %ProcedureAction{}}

  """
  def change_procedure_actions(%ProcedureAction{} = procedure_actions) do
    ProcedureAction.changeset(procedure_actions, %{})
  end

  alias HayaiLedger.Procedures.Procedure

  @doc """
  Returns the list of procedures.

  ## Examples

      iex> list_procedures()
      [%Procedure{}, ...]

  """
  def list_procedures do
    Repo.all(Procedure)
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
  def get_procedure!(id), do: Repo.get!(Procedure, id)

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

  alias HayaiLedger.Procedures.Input

  @doc """
  Returns the list of inputs.

  ## Examples

      iex> list_inputs()
      [%Input{}, ...]

  """
  def list_inputs do
    Repo.all(Input)
  end

  @doc """
  Gets a single input.

  Raises `Ecto.NoResultsError` if the Input does not exist.

  ## Examples

      iex> get_input!(123)
      %Input{}

      iex> get_input!(456)
      ** (Ecto.NoResultsError)

  """
  def get_input!(id), do: Repo.get!(Input, id)

  @doc """
  Creates a input.

  ## Examples

      iex> create_input(%{field: value})
      {:ok, %Input{}}

      iex> create_input(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_input(attrs \\ %{}) do
    %Input{}
    |> Input.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a input.

  ## Examples

      iex> update_input(input, %{field: new_value})
      {:ok, %Input{}}

      iex> update_input(input, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_input(%Input{} = input, attrs) do
    input
    |> Input.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a input.

  ## Examples

      iex> delete_input(input)
      {:ok, %Input{}}

      iex> delete_input(input)
      {:error, %Ecto.Changeset{}}

  """
  def delete_input(%Input{} = input) do
    Repo.delete(input)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking input changes.

  ## Examples

      iex> change_input(input)
      %Ecto.Changeset{source: %Input{}}

  """
  def change_input(%Input{} = input) do
    Input.changeset(input, %{})
  end

  alias HayaiLedger.Procedures.ParamsType

  @doc """
  Returns the list of params_types.

  ## Examples

      iex> list_params_types()
      [%ParamsType{}, ...]

  """
  def list_params_types do
    Repo.all(ParamsType)
  end

  @doc """
  Gets a single params_types.

  Raises `Ecto.NoResultsError` if the Params types does not exist.

  ## Examples

      iex> get_params_types!(123)
      %ParamsType{}

      iex> get_params_types!(456)
      ** (Ecto.NoResultsError)

  """
  def get_params_types!(id), do: Repo.get!(ParamsType, id)

  @doc """
  Creates a params_types.

  ## Examples

      iex> create_params_types(%{field: value})
      {:ok, %ParamsType{}}

      iex> create_params_types(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_params_types(attrs \\ %{}) do
    %ParamsType{}
    |> ParamsType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a params_types.

  ## Examples

      iex> update_params_types(params_types, %{field: new_value})
      {:ok, %ParamsType{}}

      iex> update_params_types(params_types, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_params_types(%ParamsType{} = params_types, attrs) do
    params_types
    |> ParamsType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a params_types.

  ## Examples

      iex> delete_params_types(params_types)
      {:ok, %ParamsType{}}

      iex> delete_params_types(params_types)
      {:error, %Ecto.Changeset{}}

  """
  def delete_params_types(%ParamsType{} = params_types) do
    Repo.delete(params_types)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking params_types changes.

  ## Examples

      iex> change_params_types(params_types)
      %Ecto.Changeset{source: %ParamsType{}}

  """
  def change_params_types(%ParamsType{} = params_types) do
    ParamsType.changeset(params_types, %{})
  end

  alias HayaiLedger.Procedures.TypeParam

  @doc """
  Returns the list of type_params.

  ## Examples

      iex> list_type_params()
      [%TypeParam{}, ...]

  """
  def list_type_params do
    Repo.all(TypeParam)
  end

  @doc """
  Gets a single type_param.

  Raises `Ecto.NoResultsError` if the Type param does not exist.

  ## Examples

      iex> get_type_param!(123)
      %TypeParam{}

      iex> get_type_param!(456)
      ** (Ecto.NoResultsError)

  """
  def get_type_param!(id), do: Repo.get!(TypeParam, id)

  @doc """
  Creates a type_param.

  ## Examples

      iex> create_type_param(%{field: value})
      {:ok, %TypeParam{}}

      iex> create_type_param(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_type_param(attrs \\ %{}) do
    %TypeParam{}
    |> TypeParam.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a type_param.

  ## Examples

      iex> update_type_param(type_param, %{field: new_value})
      {:ok, %TypeParam{}}

      iex> update_type_param(type_param, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_type_param(%TypeParam{} = type_param, attrs) do
    type_param
    |> TypeParam.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a type_param.

  ## Examples

      iex> delete_type_param(type_param)
      {:ok, %TypeParam{}}

      iex> delete_type_param(type_param)
      {:error, %Ecto.Changeset{}}

  """
  def delete_type_param(%TypeParam{} = type_param) do
    Repo.delete(type_param)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking type_param changes.

  ## Examples

      iex> change_type_param(type_param)
      %Ecto.Changeset{source: %TypeParam{}}

  """
  def change_type_param(%TypeParam{} = type_param) do
    TypeParam.changeset(type_param, %{})
  end
end
