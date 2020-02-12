defmodule HayaiLedgerWeb.OrganizationControllerTest do
  use HayaiLedgerWeb.ConnCase

  import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  setup do
    %{ 
      auth_conn: login(),
      organization: organization_fixture()
    }
  end

  describe "index" do
    test "lists all organizations", %{ auth_conn: auth_conn} do
      conn = get(auth_conn, Routes.organization_path(auth_conn, :index))
      assert html_response(conn, 200) =~ "Listing Organizations"
    end
  end

  describe "new organization" do
    test "renders form", %{ auth_conn: auth_conn } do
      conn = get(auth_conn, Routes.organization_path(auth_conn, :new))
      assert html_response(conn, 200) =~ "New Organization"
    end
  end

  describe "create organization" do
    test "redirects to show when data is valid", %{ auth_conn: auth_conn } do
      conn = post(auth_conn, Routes.organization_path(auth_conn, :create), organization: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.organization_path(conn, :show, id)

      conn = get(conn, Routes.organization_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Organization"
    end

    test "renders errors when data is invalid", %{ auth_conn: auth_conn } do
      conn = post(auth_conn, Routes.organization_path(auth_conn, :create), organization: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Organization"
    end
  end

  describe "edit organization" do
    test "renders form for editing chosen organization", %{ auth_conn: auth_conn, organization: organization } do
      conn = get(auth_conn, Routes.organization_path(auth_conn, :edit, organization))
      assert html_response(conn, 200) =~ "Edit Organization"
    end
  end

  describe "update organization" do
    test "redirects when data is valid", %{ auth_conn: auth_conn, organization: organization } do
      conn = put(auth_conn, Routes.organization_path(auth_conn, :update, organization), organization: @update_attrs)
      assert redirected_to(conn) == Routes.organization_path(conn, :show, organization)

      conn = get(conn, Routes.organization_path(conn, :show, organization))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{ auth_conn: auth_conn, organization: organization } do
      conn = put(auth_conn, Routes.organization_path(auth_conn, :update, organization), organization: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Organization"
    end
  end

  describe "delete organization" do
    test "deletes chosen organization", %{ auth_conn: auth_conn, organization: organization } do
      conn = delete(auth_conn, Routes.organization_path(auth_conn, :delete, organization))
      assert redirected_to(conn) == Routes.organization_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.organization_path(conn, :show, organization))
      end
    end
  end
end
