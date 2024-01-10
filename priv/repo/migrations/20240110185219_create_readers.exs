defmodule Libraryr.Repo.Migrations.CreateReaders do
  use Ecto.Migration

  def change do
    create table(:readers) do
      add :name, :string
      add :email, :string
      add :book_id, references(:books, on_delete: :nothing, column: :isbn, type: :string)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:readers, [:book_id])
  end
end
