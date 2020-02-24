defmodule HayaiLedger.Helpers do

  alias HayaiLedger.Accounts
	alias HayaiLedger.Procedures.Param
  
  @spec generate_uid() :: binary
  def generate_uid() do
    Ecto.UUID.generate
  end

  def apply_params(params, inputs, organization_id) do
    attrs_from_params(params, inputs)
    |> Map.put("organization_id", organization_id)
  end

  defp attrs_from_params(params, inputs, attrs \\ %{})

  defp attrs_from_params([], _inputs, attrs), do: attrs

  defp attrs_from_params([ param | tail ], inputs, attrs) do
    attrs_from_params(tail, inputs, put_attr(param, inputs, attrs))
  end

  defp put_attr(%Param{ name: name, type: "inputs", value: value }, inputs, attrs) do
    attr_map = Enum.find(inputs, fn(input) -> Map.has_key?(input, value) end)
    Map.put(attrs, name, attr_map[value])
  end

  defp put_attr(%Param{ name: "account_uid", type: "lookup", value: value }, inputs, attrs) do
    %{ "object_uid" => object_uid } = Enum.find(inputs, fn(input) -> find_object_attribute(input) end)
    account = Accounts.get_account_by_name(%{ name: value, object_uid: object_uid })
    Map.put(attrs, "account_uid", account.uid)
  end

  defp put_attr(%Param{ name: "amount_currency", type: "lookup", value: value }, inputs, attrs) do
    %{ "object_uid" => object_uid } = Enum.find(inputs, fn(input) -> find_object_attribute(input) end)
    account = Accounts.get_account_by_name(%{ name: value, object_uid: object_uid })
    Map.put(attrs, "amount_currency", account.currency)
  end

  defp put_attr(%Param{ name: name, value: value}, _inputs, attrs) do
    Map.put(attrs, name, value)
  end

  defp find_object_attribute(%{ "object_uid" => object_uid }), do: true

  defp find_object_attribute(_), do: false
end