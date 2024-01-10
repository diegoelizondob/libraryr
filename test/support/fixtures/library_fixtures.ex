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
        birthday: "some birthday",
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
        isbn: "some isbn",
        price: "120.5",
        title: "some title"
      })
      |> Libraryr.Library.create_book()

    book
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Libraryr.Library.create_category()

    category
  end

  @doc """
  Generate a reader.
  """
  def reader_fixture(attrs \\ %{}) do
    {:ok, reader} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> Libraryr.Library.create_reader()

    reader
  end
end
