defmodule LibraryrWeb.ReaderControllerTest do
  use LibraryrWeb.ConnCase

  import Libraryr.LibraryFixtures

  alias Libraryr.Library.Reader

  @create_attrs %{
    name: "some name",
    email: "some email"
  }
  @update_attrs %{
    name: "some updated name",
    email: "some updated email"
  }
  @invalid_attrs %{name: nil, email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all readers", %{conn: conn} do
      conn = get(conn, ~p"/api/readers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create reader" do
    test "renders reader when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/readers", reader: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/readers/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/readers", reader: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update reader" do
    setup [:create_reader]

    test "renders reader when data is valid", %{conn: conn, reader: %Reader{id: id} = reader} do
      conn = put(conn, ~p"/api/readers/#{reader}", reader: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/readers/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, reader: reader} do
      conn = put(conn, ~p"/api/readers/#{reader}", reader: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete reader" do
    setup [:create_reader]

    test "deletes chosen reader", %{conn: conn, reader: reader} do
      conn = delete(conn, ~p"/api/readers/#{reader}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/readers/#{reader}")
      end
    end
  end

  defp create_reader(_) do
    reader = reader_fixture()
    %{reader: reader}
  end
end
