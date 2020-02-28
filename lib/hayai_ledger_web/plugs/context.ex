defmodule HayaiLedgerWeb.Plugs.Context do

	@behaviour Plug

	import Plug.Conn
	import HayaiLedger.Organizations.Encryption, only: [{:verify_token, 2}]

  alias HayaiLedger.Organizations
  alias HayaiLedger.Organizations.ApiKey

	def init(opts), do: opts

  def call(conn, _) do
    with %{ organization_id: organization_id } = context <- build_context(conn) do
    	Absinthe.Plug.put_options(conn, context: context)
    else
			_ -> conn
					|> send_resp(401, "not authorized")
					|> halt()
    end
  end

  def build_context(conn) do
  	with [key_data] when is_binary(key_data) <- get_req_header(conn, "x-api-key"),
			%ApiKey{ token_salt: token_salt, organization_id: org_id } <- Organizations.get_api_key_by_data(key_data),
			{:ok, {kind, organization_id}} <- verify_token(token_salt, key_data),
			true <- organization_id == org_id
		do
			%{ organization_id: organization_id }
		else
			_ -> :error
		end
  end
end