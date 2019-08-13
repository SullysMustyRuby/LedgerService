defmodule HayaiLedger.Helpers do
  
  @spec generate_uid(non_neg_integer) :: binary
  def generate_uid(length \\ 32) when length > 0 and length < 100 do
    :crypto.strong_rand_bytes(length) |> Base.encode64
  end
end