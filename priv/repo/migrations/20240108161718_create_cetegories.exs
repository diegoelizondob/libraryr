defmodule Libraryr.Repo.Migrations.CreateCetegories do
  use Ecto.Migration

  def change do
    create table(:cetegories) do
      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
