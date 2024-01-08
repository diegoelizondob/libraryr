defmodule Libraryr.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Libraryr.Repo

  alias Libraryr.Library.{Author, Book, AuthorBook}

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
  @type book :: %Book{}

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  @spec list_books() :: [book()]
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

  @spec get_book_with_authors!(isbn :: String.t()) :: book()
  def get_book_with_authors!(isbn), do: Book |> preload(:authors) |> Repo.get!(isbn)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_book(attrs :: %{}) :: {:ok, book()} | {:error, Ecto.Changeset.t}
  def create_book(attrs \\ %{}) do
    authors =
      attrs["authors"]
      |> Enum.map(fn author ->
        {_status, authore} = find_or_create_author(%{name: String.trim(author.name), birthday: String.trim(author.birthday)})
        authore
      end)

    %Book{}
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:authors, authors)
    |> Repo.insert()
  end

  @spec delete_author_if_no_relations_left(authors :: [%Author{}]) :: :ok | :error
  def delete_author_if_no_relations_left(authors) do
    Enum.each(authors, fn author ->
      author_books_count =
        from(ab in AuthorBook, where: ab.author_id == ^author.id)
        |> Repo.aggregate(:count)

      if author_books_count == 0 do
        Repo.delete(author)
      end
    end)
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_book(isbn :: String.t(), attrs :: %{}) :: :ok
  def update_book(isbn, attrs) do
    authors =
      attrs["authors"]
      |> Enum.map(fn author ->
        {_status, authore} = find_or_create_author(%{name: String.trim(author.name), birthday: String.trim(author.birthday)})
        authore
      end)

    book = get_book_with_authors!(isbn)

    book
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:authors, authors)
    |> Repo.update()

    delete_author_if_no_relations_left(book.authors)
  end


  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_book(String.t()) :: :ok
  def delete_book(isbn) do
    # DELETE -> how to delete all relations of book (authors and author_books)
    book = get_book_with_authors!(isbn)

    # Delete authors and author_books associations
      book
      |> Repo.preload([:authors])
      |> Repo.delete()

      delete_author_if_no_relations_left(book.authors)
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

  alias Libraryr.Library.Category

  @doc """
  Returns the list of cetegories.

  ## Examples

      iex> list_cetegories()
      [%Category{}, ...]

  """
  def list_cetegories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
