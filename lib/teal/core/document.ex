defmodule Teal.Core.Document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "core_documents" do
    field :slug, :string
    field :md_content, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:slug, :md_content])
    |> validate_required([:slug, :md_content])
  end


end
