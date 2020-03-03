defmodule HayaiLedger.Helpers do
  import Ecto.Query, warn: false

  alias HayaiLedger.Accounts
	alias HayaiLedger.Procedures.Param
  
  @spec generate_uid() :: binary
  def generate_uid() do
    Ecto.UUID.generate
  end

  def add_args(query, []), do: query
  
  def add_args(query, [{:action, action} | tail]) do
    (from o in query,
      where: o.action == ^action)
    |> add_args(tail)
  end

  def add_args(query, [{:active, active} | tail]) do
    (from o in query,
      where: o.active == ^active)
    |> add_args(tail)
  end

  def add_args(query, [{:currency, currency} | tail]) do
    (from o in query,
      where: o.currency == ^currency)
    |> add_args(tail)
  end

  def add_args(query, [{:from_date, from_date} | tail]) do
    (from o in query,
      where: o.date >= ^from_date)
    |> add_args(tail)
  end

  def add_args(query, [{:offset, offset} | tail]) do
    (from o in query,
      offset: ^offset)
    |> add_args(tail)
  end

  def add_args(query, [{:limit, limit} | tail]) do
    (from o in query,
      limit: ^limit)
    |> add_args(tail)
  end

  def add_args(query, [{:name, name} | tail]) do
    (from o in query,
      where: o.name == ^name)
    |> add_args(tail)
  end

  def add_args(query, [{:object_type, object_type} | tail]) do
    (from o in query,
      where: o.object_type == ^object_type)
    |> add_args(tail)
  end

  def add_args(query, [{:to_date, to_date} | tail]) do
    (from o in query,
      where: o.date <= ^to_date)
    |> add_args(tail)
  end

  def add_args(query, [{:type, type} | tail]) do
    (from o in query,
      where: o.type == ^type)
    |> add_args(tail)
  end

  def add_args(query, [{:type, type} | tail]) do
    (from o in query,
      where: o.type == ^type)
    |> add_args(tail)
  end

  def add_args(query, [{_, _} | tail]), do: add_args(query, tail)

  def apply_params(params, inputs, organization_id) do
    attrs_from_params(params, inputs)
    |> Map.put("organization_id", organization_id)
  end

  def base_query(obj, organization_id) do
    from o in obj,
    where: o.organization_id == ^organization_id
  end

  def preload_transactions(query) do
    from o in query,
    preload: [:transactions]
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

  defp put_attr(%Param{ name: name, value: value}, _inputs, attrs) do
    Map.put(attrs, name, value)
  end

  defp find_object_attribute(%{ "object_uid" => object_uid }), do: true

  defp find_object_attribute(_), do: false
end