defmodule Libraryr.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :isbn, :string, null: false, primary_key: true
      add :title, :string
      add :price, :decimal, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:books, [:isbn])
  end
end
