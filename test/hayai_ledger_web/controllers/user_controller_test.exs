defmodule HayaiLedgerWeb.UserControllerTest do
  use HayaiLedgerWeb.ConnCase

  import Support.Fixtures.OrganizationFixtures, only: [{:user_fixture, 0}]

  @create_attrs %{ email: "some email", first_name: "first_name", last_name: "last_name", password: "password", password_confirmation: "password"}
  @invalid_attrs %{ email: nil, first_name: nil, last_name: nil, password: nil, password_confirmation: nil }

  setup do
    %{
      conn: build_conn(),
      auth_conn: login(),
      user: user_fixture()
    }
  end

  describe "index" do
    test "lists all users", %{auth_conn: auth_conn} do
      conn = get(auth_conn, Routes.user_path(auth_conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "Registration"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      refute nil == get_session(conn, "current_user_id")
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)

      conn = get(conn, Routes.dashboard_path(conn, :index))
      assert html_response(conn, 200) =~ "Dashboard"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Registration"
    end
  end

  describe "edit user" do
    test "renders form for editing chosen user", %{auth_conn: auth_conn, user: user} do
      conn = get(auth_conn, Routes.user_path(auth_conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    # test "redirects when data is valid", %{auth_conn: auth_conn, user: user} do
    #   conn = put(auth_conn, Routes.user_path(auth_conn, :update, user), user: @update_attrs)
    #   assert redirected_to(conn) == Routes.user_path(conn, :show, user)

    #   conn = get(conn, Routes.user_path(conn, :show, user))
    #   assert html_response(conn, 200) =~ "some updated first name"
    # end

    test "renders errors when data is invalid", %{auth_conn: auth_conn, user: user} do
      conn = put(auth_conn, Routes.user_path(auth_conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{auth_conn: auth_conn, user: user} do
      conn = delete(auth_conn, Routes.user_path(auth_conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end
end
