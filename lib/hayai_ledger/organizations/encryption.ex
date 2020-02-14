defmodule HayaiLedger.Organizations.Encryption do

	# The default length for the salt is 16 bytes. We do not recommend using a salt shorter than the default.
	def generate_salt(salt_len \\ 16), do: Argon2.gen_salt(salt_len)

	def generate_token(salt, data) do
		Phoenix.Token.sign(HayaiLedgerWeb.Endpoint, salt, data)
	end

	def verify_token(salt, data) do
		Phoenix.Token.verify(HayaiLedgerWeb.Endpoint, salt, data, [max_age: :infinity])
	end

  def hash_password(password), do: Argon2.hash_pwd_salt(password)

  def validate_password(user, password), do: Argon2.check_pass(user, password)
end