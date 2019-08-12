defmodule HayaiLedgerWeb.PageController do
  use HayaiLedgerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
