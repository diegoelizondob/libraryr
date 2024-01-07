defmodule Libraryr.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :isnb, :string
      add :title, :string
      add :price, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
