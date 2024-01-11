defmodule Libraryr.Library.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :name, :string
    field :birthday, :string

    timestamps(type: :utc_datetime)


  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name, :birthday])
    |> validate_required([:name, :birthday])
    |> unique_constraint(:authors_name_and_birthday, name: :name_and_birthday)
  end
end
