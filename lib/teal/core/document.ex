defmodule Teal.Core.Document do
  use Ecto.Schema

  schema "core_documents" do
    field :slug, :string
    field :md_content, :string

    timestamps()
  end
end
