defmodule HayaiLedgerWeb.Router do
  use HayaiLedgerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["html", "json"]
  end

  scope "/", HayaiLedgerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", HayaiLedgerWeb do
    pipe_through :api

    get "/accounts/:uid", AccountController, :show
    get "/accounts/balance/:uid", AccountController, :balance
    post "/accounts/create", AccountController, :create
    
    get "/entries/transactions/:uid", EntryController, :transactions_show
    get "/entries/:uid", EntryController, :show
    post "/entries/create", EntryController, :create

    get "/transactions/:uid", TransactionController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", HayaiLedgerWeb do
  #   pipe_through :api
  # end
end
