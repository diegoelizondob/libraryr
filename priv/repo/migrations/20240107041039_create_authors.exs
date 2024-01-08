defmodule Libraryr.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string, null: false
      add :birthday, :string, default: "No birthday available"

      timestamps(type: :utc_datetime)
    end

    create unique_index(:authors, [:name, :birthday], name: :name_and_birthday)
  end
end
