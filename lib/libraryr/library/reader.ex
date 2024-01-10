defmodule Libraryr.Library.Reader do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readers" do
    field :name, :string
    field :email, :string

    belongs_to :book, Libraryr.Library.Book, references: :isbn, type: :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reader, attrs) do
    reader
    |> cast(attrs, [:name, :email])
    |> validate_required([:name])
    |> foreign_key_constraint(:book_id, name: "readers_book_id_fkey")
  end
end
