defmodule Libraryr.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @derive {Phoenix.Param, key: :isbn}
  schema "books" do
    field :title, :string
    field :isbn, :string, primary_key: true
    field :price, :decimal

    many_to_many :authors, Libraryr.Library.Author, join_through: "authors_books",
                  join_keys: [isbn: :isbn, author_id: :id], on_replace: :delete

    belongs_to :category, Libraryr.Library.Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:isbn, :title, :price, :category_id])
    |> validate_required([:isbn, :title])
    |> unique_constraint(:isbn_constraint, name: "books_pkey")
    |> foreign_key_constraint(:books, name: "authors_books_isbn_fkey")
    |> foreign_key_constraint(:books, name: "books_category_id_fkey")
  end
end
