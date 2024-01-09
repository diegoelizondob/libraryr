defmodule Library.Resolvers.CategoryResolver do

  def list_categories(_parent, _args, _resolution) do
    {:ok, Libraryr.Library.list_cetegories()}
  end

end
