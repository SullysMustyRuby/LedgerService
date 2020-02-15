defmodule HayaiLedgerWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use HayaiLedgerWeb, :controller
      use HayaiLedgerWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def api_controller do
    quote do
      use Phoenix.Controller, namespace: HayaiLedgerWeb

      import Plug.Conn

      import HayaiLedgerWeb.Gettext
      import HayaiLedgerWeb.Helpers.Organization, only: [{:organization_id, 1}]
    end
  end

  def api_view do
    quote do
      use Phoenix.View,
        root: "lib/hayai_ledger_web/templates",
        namespace: HayaiLedgerWeb

      import HayaiLedgerWeb.Gettext
      
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: HayaiLedgerWeb

      import Plug.Conn
      import HayaiLedgerWeb.Gettext
      import HayaiLedgerWeb.Helpers.Auth, only: [{:current_user, 1}, {:current_user_id, 1}, {:current_user_id!, 1}]
      import HayaiLedgerWeb.Helpers.Organization, only: [{:current_organization, 1}, {:current_organization_id, 1}]
      
      alias HayaiLedgerWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/hayai_ledger_web/templates",
        namespace: HayaiLedgerWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      
      import HayaiLedgerWeb.Helpers.Auth, only: [{:signed_in?, 1}, {:signed_in?, 2}]
      import HayaiLedgerWeb.Helpers.Organization, only: [{:current_organization, 1}]
      import HayaiLedgerWeb.ErrorHelpers
      import HayaiLedgerWeb.Gettext
      
      alias HayaiLedgerWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import HayaiLedgerWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
