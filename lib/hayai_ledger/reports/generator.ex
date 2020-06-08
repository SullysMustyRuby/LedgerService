defmodule HayaiLedger.Reports.Generator do

  # import Ecto.Query, warn: false

  # alias HayaiLedger.Ledgers.Transaction
  # alias HayaiLedger.Reports.TransactionReport

	# def run_transaction_report(report, inputs) do
	# 	{date_from, date_to} = get_dates(report, inputs)
	# 	base_query(object_type, object_uid)
	# 	|> sum_query
	# end

	# defp get_dates(%TransactionReport{ date_from: "inputs", date_to: "inputs" }, %{ "date_from" => inputs_from, "date_to" => inputs_to }) do
	# 	with {:ok, date_from, from_offset} <- DateTime.from_iso8601(inputs_from),
	# 		{:ok, date_to, to_offset} <- DateTime.from_iso8601(inputs_to)
	# 	do
	# 		{date_from, date_to}
	# 	end
	# end

	# defp base_query(object_type, object_uid) do
	# 	from t in Transaction,
	# 	where: t.object_type == ^object_type,
	# 	where: t.object_uid == ^object_uid
	# end

	# defp date_query(query, date_from, date_to) do
	# 	from t in query,
	# 	where: t.date 
	# end

	# defp sum_query(query) do
	# 	from t in query,
	# 	select: sum(t.amount_subunits)
	# end

	# defp get_dates(%TransactionReport{ date_from: date_from, date_to: date_to }, _inputs) do
	# 	with {:ok, date_from, from_offset} <- DateTime.from_iso8601(inputs_from),
	# 		{:ok, date_to, to_offset} <- DateTime.from_iso8601(inputs_to)
	# 	do
	# 		{date_from, date_to}
	# 	end
	# end
end
