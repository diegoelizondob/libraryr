defmodule LibraryrWeb.ReaderController do
  use LibraryrWeb, :controller

  alias Libraryr.Library
  alias Libraryr.Library.Reader

  action_fallback LibraryrWeb.FallbackController

  def index(conn, _params) do
    readers = Library.list_readers()
    render(conn, :index, readers: readers)
  end

  def create(conn, %{"reader" => reader_params}) do
    with {:ok, %Reader{} = reader} <- Library.create_reader(reader_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/readers/#{reader}")
      |> render(:show, reader: reader)
    end
  end

  def show(conn, %{"id" => id}) do
    reader = Library.get_reader!(id)
    render(conn, :show, reader: reader)
  end

  def update(conn, %{"id" => id, "reader" => reader_params}) do
    reader = Library.get_reader!(id)

    with {:ok, %Reader{} = reader} <- Library.update_reader(reader, reader_params) do
      render(conn, :show, reader: reader)
    end
  end

  def delete(conn, %{"id" => id}) do
    reader = Library.get_reader!(id)

    with {:ok, %Reader{}} <- Library.delete_reader(reader) do
      send_resp(conn, :no_content, "")
    end
  end
end
