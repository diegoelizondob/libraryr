defmodule Libraryr.Repo.Migrations.CreateReaders do
  use Ecto.Migration

  def change do
    create table(:readers) do
      add :name, :string
      add :email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
