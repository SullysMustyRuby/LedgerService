defmodule HayaiLedger.Organizations.Encryption do
  # alias HayaiLedger.Organizations.User

  def hash_password(password), do: Argon2.hash_pwd_salt(password)

  def validate_password(user, password), do: Argon2.check_pass(user, password)
end