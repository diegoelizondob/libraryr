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

end
