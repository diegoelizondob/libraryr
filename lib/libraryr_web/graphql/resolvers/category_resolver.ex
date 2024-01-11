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
    {:ok, Libraryr.Library.get_book_with_authors!(id)}
  end

  # - Reader resolvers:

  def list_readers(_parent, _args, _resolution) do
    {:ok, Libraryr.Library.list_readers()}
  end

  def get_reader_by_name(_parent, %{id: id}, _resolution) do
    {:ok, Libraryr.Library.get_reader!(id)}
  end

  def create_reader(_parent, %{name: name, email: email}, _resolution) do
    {:ok, Libraryr.Library.create_reader(%{name: name, email: email})}
  end
  # ---------

  def create_book_with_authors(_parent, args, _resolution) do
    IO.puts("args of createBooks resolver: #{inspect args}")
    Libraryr.Library.create_book(args)
  end

end
