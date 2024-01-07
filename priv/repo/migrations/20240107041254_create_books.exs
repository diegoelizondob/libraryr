defmodule Libraryr.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :isbn, :string, null: false, primary_key: true
      add :title, :string
      add :price, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
