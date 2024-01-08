defmodule LibraryrWeb.CategoryJSON do
  alias Libraryr.Library.Category

  @doc """
  Renders a list of cetegories.
  """
  def index(%{cetegories: cetegories}) do
    %{data: for(category <- cetegories, do: data(category))}
  end

  @doc """
  Renders a single category.
  """
  def show(%{category: category}) do
    %{data: data(category)}
  end

  defp data(%Category{} = category) do
    %{
      id: category.id,
      name: category.name
    }
  end
end
