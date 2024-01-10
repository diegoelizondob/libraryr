defmodule Libraryr.Repo.Migrations.CreateReaders do
  use Ecto.Migration

  def change do
    create table(:readers) do
      add :name, :string
      add :email, :string
      add :isbn, references(:books, on_delete: :nothing, column: :isbn, type: :string)

      timestamps(type: :utc_datetime)
    end

    create index(:readers, [:isbn])
  end
end
