defmodule Libraryr.Library.AuthorBook do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "authors_books" do

    field :author_id, :id, primary_key: true
    field :isbn, :string, primary_key: true
  end

  @doc false
  def changeset(author_book, attrs) do
    author_book
    |> cast(attrs, [])
    |> validate_required([])
  end
end
