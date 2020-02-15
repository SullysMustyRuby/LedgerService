defmodule HayaiLedgerWeb.Router do
  use HayaiLedgerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HayaiLedgerWeb.Plugs.Auth
    plug HayaiLedgerWeb.Plugs.Organization
  end

  pipeline :public_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {HayaiLedgerWeb.PublicView, "main.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug HayaiLedgerWeb.Plugs.ApiAuth
  end

  scope "/", HayaiLedgerWeb do
    pipe_through :public_browser

    get "/", PublicController, :index

    resources "/register", UserController, only: [:create, :new]
    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", HayaiLedgerWeb do
    pipe_through :browser

    delete "/logout", SessionController, :delete

    resources "/api_keys", ApiKeyController, only: [:index, :show]
    resources "/accounts", AccountController, except: [:delete]
    resources "/entries", EntryController, only: [:index, :show]
    resources "/organizations", OrganizationController
    resources "/transactions", TransactionController, only: [:index, :show]
    resources "/users", UserController, except: [:create, :new]
    get "/dashboard", DashboardController, :index
  end

  scope "/api", as: :api  do
    pipe_through :api

    get "/accounts/:uid", HayaiLedgerWeb.Api.AccountController, :show
    get "/accounts/balance/:uid", HayaiLedgerWeb.Api.AccountController, :balance
    get "/accounts/running_balance/:uid", HayaiLedgerWeb.Api.AccountController, :running_balance
    get "/accounts/transactions/:uid", HayaiLedgerWeb.Api.AccountController, :transactions
    post "/accounts/create", HayaiLedgerWeb.Api.AccountController, :create
    
    get "/entries/:uid", HayaiLedgerWeb.Api.EntryController, :show
    post "/entries/create", HayaiLedgerWeb.Api.EntryController, :create

    get "/transactions/:uid", HayaiLedgerWeb.Api.TransactionController, :show
  end
end
