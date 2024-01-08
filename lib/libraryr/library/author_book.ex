defmodule Libraryr.Library.AuthorBook do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "authors_books" do
    belongs_to :author, Libraryr.Library.Author, primary_key: true
    belongs_to :book, Libraryr.Library.Book, primary_key: true, references: :isbn
  end

  @doc false
  def changeset(author_book, attrs) do
    author_book
    |> cast(attrs, [])
    |> validate_required([:isbn, :author_id])
  end
end
