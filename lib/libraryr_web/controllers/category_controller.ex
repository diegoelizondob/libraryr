defmodule LibraryrWeb.CategoryController do
  use LibraryrWeb, :controller

  alias Libraryr.Library
  alias Libraryr.Library.Category

  action_fallback LibraryrWeb.FallbackController

  def index(conn, _params) do
    cetegories = Library.list_cetegories()
    render(conn, :index, cetegories: cetegories)
  end

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <- Library.create_category(category_params) do
      conn
      |> put_status(:created)
      |> render(:show, category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Library.get_category!(id)
    render(conn, :show, category: category)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Library.get_category!(id)

    with {:ok, %Category{} = category} <- Library.update_category(category, category_params) do
      render(conn, :show, category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Library.get_category!(id)

    with {:ok, %Category{}} <- Library.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end
end
