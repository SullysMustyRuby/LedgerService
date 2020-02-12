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

    resources "/users", UserController
    resources "/organizations", OrganizationController
  end

  scope "/", HayaiLedgerWeb do
    pipe_through :api

    get "/accounts/:uid", AccountController, :show
    get "/accounts/balance/:uid", AccountController, :balance
    get "/accounts/running_balance/:uid", AccountController, :running_balance
    get "/accounts/transactions/:uid", AccountController, :transactions
    post "/accounts/create", AccountController, :create
    
    get "/entries/:uid", EntryController, :show
    post "/entries/create", EntryController, :create

    get "/transactions/:uid", TransactionController, :show
  end
end
