defmodule HayaiLedgerWeb.FallbackController do
  @moduledoc """
  Rescues controller action failures and renders accordingly.

  External errors induced by users e.g. typos, malformed data, invalid
  input are matched with `:user_error` and will not be sent to Sentry.
  Specific error objects will be rendered.

  Internal errors and server errors are matched with `:error` and
  will be reported to Sentry for debugging purposes.
  In this case, an `internal_error` will be rendered.

  """
  use HayaiLedgerWeb, :controller

  # External errors

  # def call(conn, {:user_error, %HTTPoison.Response{ body: error } }) do
  #   conn
  #   |> render("error.json", %{ body: error })
  # end

  # def call(conn, {:user_error, %{ status_code: code, body: error } }) do
  #   conn
  #   |> put_status(code)
  #   |> render("error.json", %{ body: error })
  # end

  # def call(conn, {:user_error, error}) do
  #   conn
  #   |> render("error.json", %{ body: error })
  # end

  # # Internal errors

  def call(conn, {:error, %Ecto.Changeset{ errors: errors } }) do
    conn
    |> put_status(500)
    |> render("error.json", %{ errors: error_map(errors) })
  end

  def call(conn, {:error, message }) when is_binary(message) do
    conn
    |> put_status(500)
    |> render("error.json", %{ errors: %{ error: message } })
  end

  defp error_map(errors) do
    for {key, {message, _}} <- errors, into: %{} do
      {key, message}
    end
  end

end
