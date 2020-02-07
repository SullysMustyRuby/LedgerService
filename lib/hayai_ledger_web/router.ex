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
    plug :accepts, ["json"]
  end

  scope "/", HayaiLedgerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", HayaiLedgerWeb do
    pipe_through :api

    post "entries/create", EntryController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", HayaiLedgerWeb do
  #   pipe_through :api
  # end
end
