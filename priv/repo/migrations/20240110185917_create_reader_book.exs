defmodule Libraryr.Repo.Migrations.CreateReaderBook do
  use Ecto.Migration

  def change do
    create table(:reader_book) do
      add :readers_books, :string
      add :reader_id, references(:readers, on_delete: :nothing)
      add :isbn, references(:books, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:reader_book, [:reader_id])
    create index(:reader_book, [:isbn])
  end
end
