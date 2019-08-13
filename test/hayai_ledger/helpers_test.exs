defmodule HayaiLedger.HelpersTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Helpers

  describe "generate_uid/0" do
    test "returns an ecto uuid" do
      uid = Helpers.generate_uid
      assert 36 == byte_size(uid)
    end
  end
end