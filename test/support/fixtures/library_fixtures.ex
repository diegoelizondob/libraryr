defmodule Libraryr.LibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Libraryr.Library` context.
  """

  @doc """
  Generate a author.
  """
  def author_fixture(attrs \\ %{}) do
    {:ok, author} =
      attrs
      |> Enum.into(%{
        address: "some address",
        last_name: "some last_name",
        name: "some name"
      })
      |> Libraryr.Library.create_author()

    author
  end

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        isnb: "some isnb",
        price: "120.5",
        title: "some title"
      })
      |> Libraryr.Library.create_book()

    book
  end
end
