defmodule HayaiLedger.Organizations.UserTest do
	use HayaiLedger.DataCase

	import Support.Fixtures.OrganizationFixtures, only: [{:user_attrs, 0}]

	alias HayaiLedger.Organizations
	alias HayaiLedger.Organizations.User

	describe "validations" do
		test "returns error witout an email" do
			no_email = Map.delete(user_attrs(), :email)
			changeset = User.changeset(%User{}, no_email)
			refute changeset.valid?
			assert {"can't be blank", [validation: :required]} == changeset.errors[:email]
		end

		test "email must be unique" do
			{:ok, shina1} = Organizations.create_user(user_attrs())
			bad_email = Map.put(user_attrs(), :email, shina1.email)
			{:error, changeset} = Organizations.create_user(bad_email)
			refute changeset.valid?
			assert {"has already been taken", [{:constraint, :unique}, {:constraint_name, "users_email_index"}]} == changeset.errors[:email]
		end

		test "returns error witout a password" do
			no_password = Map.delete(user_attrs(), :password)
			changeset = User.changeset(%User{}, no_password)
			refute changeset.valid?
			assert {"can't be blank", [validation: :required]} == changeset.errors[:password]
		end

		test "returns error witout an password_confirmation" do
			no_confirmation = Map.delete(user_attrs(), :password_confirmation)
			changeset = User.changeset(%User{}, no_confirmation)
			refute changeset.valid?
			assert {"can't be blank", [validation: :required]} == changeset.errors[:password_confirmation]
		end

		test "returns error if password and password_confirmation don't match" do
			bad_match = Map.put(user_attrs(), :password_confirmation, "not spleem")
			changeset = User.changeset(%User{}, bad_match)
			refute changeset.valid?
			assert {"does not match confirmation", [validation: :confirmation]} == changeset.errors[:password_confirmation]
		end

		test "returns error witout a first_name" do
			no_first_name = Map.delete(user_attrs(), :first_name)
			changeset = User.changeset(%User{}, no_first_name)
			refute changeset.valid?
			assert {"can't be blank", [validation: :required]} == changeset.errors[:first_name]
		end

		test "returns error witout a last_name" do
			no_last_name = Map.delete(user_attrs(), :last_name)
			changeset = User.changeset(%User{}, no_last_name)
			refute changeset.valid?
			assert {"can't be blank", [validation: :required]} == changeset.errors[:last_name]
		end

		test "returns a user if all validations pass" do
			user = User.changeset(%User{}, user_attrs())
			assert user.valid?
			assert {:ok, "shina"} == fetch_change(user, :first_name)
			assert {:ok, "ringo"} == fetch_change(user, :last_name)
			{:ok, encrypted_password} = fetch_change(user, :encrypted_password)
			refute is_nil(encrypted_password)
		end
	end
end
