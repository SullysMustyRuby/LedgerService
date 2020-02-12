defmodule HayaiLedgerWeb.PublicController do
  use HayaiLedgerWeb, :controller

  # GET
  def index(conn, _params) do
  	conn
  	|> render("index.html")
  end
end
