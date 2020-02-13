defmodule HayaiLedgerWeb.Router do
  use HayaiLedgerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :public_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(:put_layout, {HayaiLedgerWeb.PublicView, "main.html"})
  end

  pipeline :api do
    plug :accepts, ["html", "json"]
  end

  scope "/", HayaiLedgerWeb do
    pipe_through :public_browser

    get "/", PublicController, :index

    resources "/register", UserController, only: [:create, :new]
    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", HayaiLedgerWeb do
    pipe_through [:browser, HayaiLedgerWeb.Plugs.Auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    resources "/users", UserController, except: [:create, :new]
    resources "/organizations", OrganizationController
    get "/dashboard", DashboardController, :index
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

  # scope "/", HayaiLedgerWeb do
  #   pipe_through [:browser, HayaiLedgerWeb.Plugs.Guest] #hmm not sure why we do this?

    # resources "/register", UserController, only: [:create, :new]
    # get "/login", SessionController, :new
    # post "/login", SessionController, :create
  # end
