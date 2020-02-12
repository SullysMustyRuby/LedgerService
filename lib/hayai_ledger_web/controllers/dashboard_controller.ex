defmodule HayaiLedgerWeb.DashboardController do
  use HayaiLedgerWeb, :controller

  def index(conn, _params) do
  	conn
  	|> render("index.html")
  end
end
