defmodule HayaiLedgerWeb.EntryView do
  use HayaiLedgerWeb, :view

  def render("show.json", %{ entry: entry }) when is_map(entry) do
  	%{
      "object" => "Entry",
			"description" => entry.description,
			"object_type" => entry.object_type,
			"object_uid" => entry.object_uid,
			"uid" => entry.uid,
		}
  end

  def render("error.json", %{ errors: errors }) do
  	errors
  end
end
