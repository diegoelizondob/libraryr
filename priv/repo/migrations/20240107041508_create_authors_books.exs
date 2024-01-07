defmodule Libraryr.Repo.Migrations.CreateAuthorsBooks do
  use Ecto.Migration

  def change do
    create table(:authors_books) do
      add :author_id, references(:posts, on_delete: :nothing)
      add :book_id, references(:books, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:authors_books, [:author_id])
    create index(:authors_books, [:book_id])
  end
end
