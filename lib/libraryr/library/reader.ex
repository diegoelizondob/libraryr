defmodule Libraryr.Library.Reader do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readers" do
    field :name, :string
    field :email, :string

    belongs_to :books, Libraryr.Library.Book, references: :isbn, type: :string, foreign_key: :isbn

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reader, attrs) do
    reader
    |> cast(attrs, [:name, :email, :isbn])
    |> validate_required([:name])
    |> foreign_key_constraint(:books, name: "readers_isbn_fkey")
  end
end
