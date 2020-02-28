 defmodule HayaiLedgerWeb.Plugs.ApiAuth do

 	import Plug.Conn
  import HayaiLedger.Organizations.Encryption, only: [{:verify_token, 2}]

  alias HayaiLedger.Organizations
  alias HayaiLedger.Organizations.ApiKey

  def init(opts), do: opts

  def call(conn, _opts) do
		with [key_data] when is_binary(key_data) <- Plug.Conn.get_req_header(conn, "x-api-key"),
			%ApiKey{ token_salt: token_salt, organization_id: org_id } <- Organizations.get_api_key_by_data(key_data),
			{:ok, {kind, organization_id}} <- verify_token(token_salt, key_data),
			true <- organization_id == org_id
		do
			conn
			|> fetch_session()
			|> put_session(:organization_id, organization_id)
			|> put_session(:api_permission, kind)
		else
			_ -> conn
					|> send_resp(401, "not authorized")
					|> halt()
		end
  end
end
