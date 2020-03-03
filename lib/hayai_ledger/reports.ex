defmodule HayaiLedger.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false

  alias HayaiLedger.Repo
  alias HayaiLedger.Reports.{Generator, ReportAccount, TransactionReport}

  # def generate(%{ "name" => name, "inputs" => inputs }, organization_id) do
  #   with {:ok, report} <- get_report_by_name(name, organization_id) do
  #     Generator.run_transaction_report(report, inputs)
  #   end
  # end

  def get_report_by_name(name, organization_id) do
    case Repo.one(report_by_name_query(name, organization_id)) do
      %TransactionReport{} = report -> {:ok, report}
      _ -> {:error, "no report with that name"}
    end
  end

  defp report_by_name_query(name, organization_id) do
    from t in TransactionReport,
    where: t.name == ^name,
    where: t.organization_id == ^organization_id,
    select: t,
    preload: [:accounts]
  end

  @doc """
  Returns the list of transaction_reports.

  ## Examples

      iex> list_transaction_reports()
      [%TransactionReport{}, ...]

  """
  def list_transaction_reports do
    Repo.all(TransactionReport)
  end

  @doc """
  Gets a single transaction_report.

  Raises `Ecto.NoResultsError` if the Transaction report does not exist.

  ## Examples

      iex> get_transaction_report!(123)
      %TransactionReport{}

      iex> get_transaction_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction_report!(id), do: Repo.get!(TransactionReport, id)

  @doc """
  Creates a transaction_report.

  ## Examples

      iex> create_transaction_report(%{field: value})
      {:ok, %TransactionReport{}}

      iex> create_transaction_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction_report(attrs \\ %{}) do
    %TransactionReport{}
    |> TransactionReport.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction_report.

  ## Examples

      iex> update_transaction_report(transaction_report, %{field: new_value})
      {:ok, %TransactionReport{}}

      iex> update_transaction_report(transaction_report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction_report(%TransactionReport{} = transaction_report, attrs) do
    transaction_report
    |> TransactionReport.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction_report.

  ## Examples

      iex> delete_transaction_report(transaction_report)
      {:ok, %TransactionReport{}}

      iex> delete_transaction_report(transaction_report)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction_report(%TransactionReport{} = transaction_report) do
    Repo.delete(transaction_report)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction_report changes.

  ## Examples

      iex> change_transaction_report(transaction_report)
      %Ecto.Changeset{source: %TransactionReport{}}

  """
  def change_transaction_report(%TransactionReport{} = transaction_report) do
    TransactionReport.changeset(transaction_report, %{})
  end

  @doc """
  Returns the list of report_accounts.

  ## Examples

      iex> list_report_accounts()
      [%ReportAccount{}, ...]

  """
  def list_report_accounts do
    Repo.all(ReportAccount)
  end

  @doc """
  Gets a single report_account.

  Raises `Ecto.NoResultsError` if the Report account does not exist.

  ## Examples

      iex> get_report_account!(123)
      %ReportAccount{}

      iex> get_report_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_report_account!(id), do: Repo.get!(ReportAccount, id)

  @doc """
  Creates a report_account.

  ## Examples

      iex> create_report_account(%{field: value})
      {:ok, %ReportAccount{}}

      iex> create_report_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_report_account(attrs \\ %{}) do
    %ReportAccount{}
    |> ReportAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a report_account.

  ## Examples

      iex> update_report_account(report_account, %{field: new_value})
      {:ok, %ReportAccount{}}

      iex> update_report_account(report_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_report_account(%ReportAccount{} = report_account, attrs) do
    report_account
    |> ReportAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a report_account.

  ## Examples

      iex> delete_report_account(report_account)
      {:ok, %ReportAccount{}}

      iex> delete_report_account(report_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_report_account(%ReportAccount{} = report_account) do
    Repo.delete(report_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report_account changes.

  ## Examples

      iex> change_report_account(report_account)
      %Ecto.Changeset{source: %ReportAccount{}}

  """
  def change_report_account(%ReportAccount{} = report_account) do
    ReportAccount.changeset(report_account, %{})
  end
end
