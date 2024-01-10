defmodule Libraryr.Library.Reader do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readers" do
    field :name, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reader, attrs) do
    reader
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
