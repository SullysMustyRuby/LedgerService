defmodule HayaiLedger.Organizations.Authentication do
  # alias HayaiLedger.Organizations.User

  def hash_password(password), do: Argon2.hash_pwd_salt(password)

  # def validate_password(%User{} = user, password), do: Argon2.verify_pass(user, password)
end