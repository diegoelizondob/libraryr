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
    author = Repo.get_by(Author, name: attrs.name || attrs["name"], birthday: attrs.birthday || attrs["birthday"])
    IO.puts("authors found in repo: #{inspect author}")
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
    Book |> preload(:authors) |> preload(:category) |> Repo.all()
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

  @spec get_book_with_authors(isbn :: String.t()) :: book()
  def get_book_with_authors(isbn), do: Book |> preload(:authors) |> Repo.get_by(isbn: isbn)

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
      attrs.authors
      |> Enum.map(fn author ->
        {_status, authore} = find_or_create_author(%{name: String.trim(author.name), birthday: String.trim(author.birthday)})
        authore
      end)

      IO.puts("authors found: #{inspect authors}")

    {status, changeset} =
    %Book{}
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:authors, authors)
    |> Repo.insert()

    # absinthe no puede mostrar el changeset como mensaje de error, entonces se convierte a string
    case status do
      :ok -> {status, changeset}
      :error -> {status, "hubieron errores en el changeset..."}
    end
  end

  @spec delete_author_if_no_relations_left(authors :: [%Author{}]) :: :ok | :error
  def delete_author_if_no_relations_left(authors) do
    Enum.each(authors, fn author ->
      author_books_count =
        from(ab in AuthorBook, where: ab.author_id == ^author.id)
        |> Repo.aggregate(:count)

      if author_books_count == 0 do
        Repo.delete(author)
      else
        :ok
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

    book = get_book_with_authors(isbn)

    books = book
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:authors, authors)
    |> Repo.update()

    IO.puts("books deleted? : #{inspect books}")

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
    book = get_book_with_authors(isbn)

    case book do
      nil -> :error
    book ->
      book
      |> Repo.preload([:authors])
      |> Repo.preload([:readers])
      |> Repo.delete()

      delete_author_if_no_relations_left(book.authors)
    end
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
    Category |> preload(:books) |> Repo.all()
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

  alias Libraryr.Library.Reader

  @doc """
  Returns the list of readers.

  ## Examples

      iex> list_readers()
      [%Reader{}, ...]

  """
  def list_readers do
    Repo.all(Reader)
  end

  @doc """
  Gets a single reader.

  Raises `Ecto.NoResultsError` if the Reader does not exist.

  ## Examples

      iex> get_reader!(123)
      %Reader{}

      iex> get_reader!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reader!(id), do: Repo.get!(Reader, id)

  @doc """
  Creates a reader.

  ## Examples

      iex> create_reader(%{field: value})
      {:ok, %Reader{}}

      iex> create_reader(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reader(attrs \\ %{}) do
    %Reader{}
    |> Reader.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reader.

  ## Examples

      iex> update_reader(reader, %{field: new_value})
      {:ok, %Reader{}}

      iex> update_reader(reader, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reader(%Reader{} = reader, attrs) do
    reader
    |> Reader.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reader.

  ## Examples

      iex> delete_reader(reader)
      {:ok, %Reader{}}

      iex> delete_reader(reader)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reader(%Reader{} = reader) do
    Repo.delete(reader)
  end

  def delete_reader_by_id(id) do
    # https://elixirforum.com/t/ecto-delete-a-record-without-selecting-first/20024
    IO.puts "from(x in Reader, where: x.id == ^id)"
    IO.inspect from(x in Reader, where: x.id == ^id)

    from(x in Reader, where: x.id == ^id)
    |> Repo.delete_all
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reader changes.

  ## Examples

      iex> change_reader(reader)
      %Ecto.Changeset{data: %Reader{}}

  """
  def change_reader(%Reader{} = reader, attrs \\ %{}) do
    Reader.changeset(reader, attrs)
  end
end
