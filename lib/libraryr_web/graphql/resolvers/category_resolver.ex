defmodule Library.Resolvers.CategoryResolver do

  def list_categories(_parent, _args, _resolution) do
    {:ok, Libraryr.Library.list_cetegories()}
  end

  def list_authors(_parent, _args, _resolution) do
    {:ok, Libraryr.Library.list_authors()}
  end

  def list_books(_parent, _args, _resolution) do
    {:ok, Libraryr.Library.list_books()}
  end

  def get_book_by_isbn(_parent, %{isbn: id}, _resolution) do
    {:ok, Libraryr.Library.get_book_with_authors(id)}
  end

  # - Reader resolvers:

  def list_readers(_parent, _args, _resolution) do
    {:ok, Libraryr.Library.list_readers()}
  end

  def get_reader_by_name(_parent, %{id: id}, _resolution) do
    {:ok, Libraryr.Library.get_reader!(id)}
  end

  def create_reader(_parent, %{name: name, email: email, isbn: isbn}, _resolution) do
    Libraryr.Library.create_reader(%{name: name, email: email, isbn: isbn})
  end

  def delete_reader_by_id(_parent, %{id: id}, _resolution) do

    result_tuple = Libraryr.Library.delete_reader_by_id(id)

    case result_tuple do
      {1, nil} ->
        {:ok, %{message: "success, deleted reader id: #{id}."}}
      {0, nil} ->
        {:error, %{message: "error, id #{id} does not exist, deleted nothing."}}
    end

    #{:ok, Libraryr.Library.delete_reader_by_id(id)}
  end
  # ---------

  def create_book_with_authors(_parent, args, _resolution) do
    IO.puts("args of createBooks resolver: #{inspect args}")
    Libraryr.Library.create_book(args)
  end

  def delete_book_with_authors(_parent, %{isbn: isbn}, _resolution) do
    status = Libraryr.Library.delete_book(isbn)
    case status do
      :ok ->
        {:ok, "se borro exitosamente el libro con isbn '#{isbn}', con sus relaciones correspondientes"}
      :error ->
        {:error, "hubo un error al intentar borrar el libro con isbn '#{isbn}'"}
      _ ->
        {:error, "algo sucedio mal..."}
      end
  end
end
