defmodule Teal.Repo.Migrations.CreateTeal.Core.Document do
  use Ecto.Migration

  def change do
    create table(:core_documents) do
      add :slug, :string
      add :md_content, :text
      timestamps()
    end

    create unique_index(:core_documents, [:slug], unique: true)

  end
end
