defmodule Libraryr.Library.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cetegories" do
    field :name, :string
    has_many :books, Libraryr.Library.Book

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
