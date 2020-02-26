defmodule HayaiLedger.ReportsTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]
  import Support.Fixtures.ReportFixtures

  alias HayaiLedger.Accounts
  alias HayaiLedger.Reports
  alias HayaiLedger.Reports.{ReportAccount, TransactionReport}

  describe "transaction_reports" do

    @update_attrs %{ date_from: "beginning_of_today", date_to: "end_of_today", name: "TodayNetSale", type: "list" }
    @invalid_attrs %{ date_from: nil, date_to: nil, field: nil, name: nil, timezone: nil, type: nil }

    test "list_transaction_reports/0 returns all transaction_reports" do
      transaction_report = transaction_report_fixture()
      assert Reports.list_transaction_reports() == [transaction_report]
    end

    test "get_transaction_report!/1 returns the transaction_report with given id" do
      transaction_report = transaction_report_fixture()
      assert Reports.get_transaction_report!(transaction_report.id) == transaction_report
    end

    test "create_transaction_report/1 with valid data creates a transaction_report" do
      assert {:ok, %TransactionReport{} = transaction_report} = Reports.create_transaction_report(transaction_report_attrs())
      assert transaction_report.date_from == "inputs"
      assert transaction_report.date_to == "inputs"
      assert transaction_report.field == "amount_subunits"
      assert transaction_report.name == "NetSalesReport"
      assert transaction_report.timezone == "Asia/Bangkok"
      assert transaction_report.type == "sum"
    end

    test "create_transaction_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_transaction_report(@invalid_attrs)
    end

    test "update_transaction_report/2 with valid data updates the transaction_report" do
      transaction_report = transaction_report_fixture()
      assert {:ok, %TransactionReport{} = transaction_report} = Reports.update_transaction_report(transaction_report, @update_attrs)
      assert transaction_report.date_from == "beginning_of_today"
      assert transaction_report.date_to == "end_of_today"
      assert transaction_report.name == "TodayNetSale"
      assert transaction_report.type == "list"
    end

    test "update_transaction_report/2 with invalid data returns error changeset" do
      transaction_report = transaction_report_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_transaction_report(transaction_report, @invalid_attrs)
      assert transaction_report == Reports.get_transaction_report!(transaction_report.id)
    end

    test "delete_transaction_report/1 deletes the transaction_report" do
      transaction_report = transaction_report_fixture()
      assert {:ok, %TransactionReport{}} = Reports.delete_transaction_report(transaction_report)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_transaction_report!(transaction_report.id) end
    end

    test "change_transaction_report/1 returns a transaction_report changeset" do
      transaction_report = transaction_report_fixture()
      assert %Ecto.Changeset{} = Reports.change_transaction_report(transaction_report)
    end
  end

  describe "report_accounts" do

    @update_attrs %{name: "CreditCardSales", object_type: "Sale", object_uid: "sale_987654321"}
    @invalid_attrs %{name: nil, object_type: nil, object_uid: nil}

    test "list_report_accounts/0 returns all report_accounts" do
      report_account = report_account_fixture()
      assert Reports.list_report_accounts() == [report_account]
    end

    test "get_report_account!/1 returns the report_account with given id" do
      report_account = report_account_fixture()
      assert Reports.get_report_account!(report_account.id) == report_account
    end

    test "create_report_account/1 with valid data creates a report_account" do
      assert {:ok, %ReportAccount{} = report_account} = Reports.create_report_account(report_account_attrs())
      assert report_account.name == "CashSales"
      assert report_account.object_type == "Site"
      assert report_account.object_uid == "site_123456789"
    end

    test "create_report_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_report_account(@invalid_attrs)
    end

    test "update_report_account/2 with valid data updates the report_account" do
      report_account = report_account_fixture()
      assert {:ok, %ReportAccount{} = report_account} = Reports.update_report_account(report_account, @update_attrs)
      assert report_account.name == "CreditCardSales"
      assert report_account.object_type == "Sale"
      assert report_account.object_uid == "sale_987654321"
    end

    test "update_report_account/2 with invalid data returns error changeset" do
      report_account = report_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_report_account(report_account, @invalid_attrs)
      assert report_account == Reports.get_report_account!(report_account.id)
    end

    test "delete_report_account/1 deletes the report_account" do
      report_account = report_account_fixture()
      assert {:ok, %ReportAccount{}} = Reports.delete_report_account(report_account)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_report_account!(report_account.id) end
    end

    test "change_report_account/1 returns a report_account changeset" do
      report_account = report_account_fixture()
      assert %Ecto.Changeset{} = Reports.change_report_account(report_account)
    end
  end

  describe "generate/1" do
    setup do
      %{ organization: organization_fixture() }
    end

    test "returns the result data with valid params", %{ organization: organization } do
      date_from = "2015-01-01T00:00:07Z"
      date_to = "2020-01-31T23:59:59Z"
      object_uid = "site_123456789"
      create_account("CashSales", object_uid, "asset", organization.id)
      create_account("CreditCardSales", object_uid, "asset", organization.id)
      report = net_sales_report(organization.id)
      params = net_sales_report_params(date_from, date_to, object_uid)

      Reports.generate(params, organization.id)
    end
  end

  defp create_account(name, object_uid, type, organization_id) do
    {:ok, account} = Accounts.create_account(%{
      "currency" => "THB",
      "name" => name,
      "object_type" => "Account",
      "object_uid" => object_uid,
      "type" => type,
      "organization_id" => organization_id
    })
    
    account
  end
end
