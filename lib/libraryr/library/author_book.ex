defmodule Libraryr.Library.AuthorBook do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors_books" do

    field :author_id, :id
    field :isbn, :string
  end

  @doc false
  def changeset(author_book, attrs) do
    author_book
    |> cast(attrs, [])
    |> validate_required([])
  end
end
