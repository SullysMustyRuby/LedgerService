defmodule HayaiLedger.Helpers do
  
  @spec generate_uid() :: binary
  def generate_uid() do
    Ecto.UUID.generate
  end
end