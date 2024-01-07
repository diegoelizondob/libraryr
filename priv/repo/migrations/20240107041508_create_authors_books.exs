defmodule Libraryr.Repo.Migrations.CreateAuthorsBooks do
  use Ecto.Migration

  def change do
    create table(:authors_books, primary_key: false) do # primary_key false
      add :author_id, references(:authors, on_delete: :nothing), null: false, primary_key: true
      add :isbn, references(:books, on_delete: :nothing, column: :isbn, type: :string), null: false, primary_key: true
    end

    create index(:authors_books, [:author_id])
    create index(:authors_books, [:isbn])
  end
end
