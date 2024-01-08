defmodule Libraryr.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Libraryr.Repo

  alias Libraryr.Library.{Author, Book}

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  def find_or_create_author(attrs) do
    author = Repo.get_by(Author, name: attrs[:name] || attrs["name"], birthday: attrs[:birthday] || attrs["birthday"])

    case author do
      nil ->
        create_author(attrs)
    author ->
      {:ok, author}
    end
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{data: %Author{}}

  """
  def change_author(%Author{} = author, attrs \\ %{}) do
    Author.changeset(author, attrs)
  end

  alias Libraryr.Library.Book

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Book |> preload(:authors) |> Repo.all()
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)
  def get_book_with_authors!(id), do: Book |> preload(:authors) |> Repo.get!(id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    authors =
      attrs["authors"]
      |> Enum.map(fn author ->
        {_status, authore} = find_or_create_author(%{name: String.trim(author["name"]), birthday: String.trim(author["birthday"])})
        authore
      end)

    %Book{}
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:authors, authors)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(isbn, attrs) do
    authors =
      attrs["authors"]
      |> Enum.map(fn author ->
        IO.puts("author: #{inspect author}")
        {_status, authore} = find_or_create_author(%{name: String.trim(author["name"]), birthday: String.trim(author["birthday"])})
        authore
      end)

    book = get_book_with_authors!(isbn)
    IO.puts("book with isbn #{isbn}: #{inspect book}")

    book
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:authors, authors)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(isbn) do
    # DELETE -> how to delete all relations of book (authors and author_books)
    book = get_book_with_authors!(isbn)

    book
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end
end
