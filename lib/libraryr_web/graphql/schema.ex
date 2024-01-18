defmodule LibraryWeb.GraphQL.Schema do
  @moduledoc """
  The Absinthe schema for the application.
  """
  use Absinthe.Schema
  alias Library.Resolvers.CategoryResolver

  import_types Absinthe.Type.Custom

  query do
    @desc "Get authors list"
    field :author, list_of(:author) do
      resolve &CategoryResolver.list_authors/3
    end

    @desc "Get books list"
    field :book, list_of(:books) do
      resolve &CategoryResolver.list_books/3
    end

    @desc "Get one book by isbn"
    field :one_book, :books do
      arg :isbn, non_null(:id)
      resolve &CategoryResolver.get_book_by_isbn/3
    end

    @desc "Get the current user"
    field :category, list_of(:category) do
      resolve &CategoryResolver.list_categories/3
    end

    # - Readers queries:

    @desc "Get list of readers"
    field :readers, list_of(:reader) do
      resolve &CategoryResolver.list_readers/3
    end

    @desc "Get one reader by id"
    field :one_reader, :reader do
      arg :id, non_null(:id)
      resolve &CategoryResolver.get_reader_by_name/3
    end
    # ------------
  end

  mutation do
    @desc "Create a book with authors"
    field :create_book_with_authors, :books do
      arg :isbn, non_null(:string)
      arg :title, non_null(:string)
      arg :authors, list_of(:author_input)
      arg :category_id, :integer
      resolve &CategoryResolver.create_book_with_authors/3
    end

    @desc "delete a book with authors"
    field :delete_book_with_authors, type: non_null(:string) do
      arg :isbn, non_null(:string)
      resolve &CategoryResolver.delete_book_with_authors/3
    end

    # - Readers mutations:
    @desc "Create a reader"
    field :create_reader, type: :reader do
      arg :name, :string
      arg :email, :string
      arg :isbn, :string
      resolve &CategoryResolver.create_reader/3
    end

    @desc "Delete one reader"
    field :delete_reader, type: :delete_reader_obj do
      arg :isbn, non_null(:string)
      resolve &CategoryResolver.delete_reader_by_id/3
    end

    # ----------
  end

  subscription do
    @desc "subscribe to changes to  authors"
    field :authors_change, list_of(:author) do
      config fn _args, _res ->
        IO.puts "were here!!!!"
        {:ok, topic: :authors_change}
      end
    end
  end

  object :delete_book_obj do
    field :msg, non_null(:string)
  end

  object :delete_reader_obj do
    field :message, :string
  end

  input_object :author_input do
    field :name, non_null(:string)
    field :birthday, :string
  end

  object :author do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :updated_at, :datetime
  end

  #query do
  #  @desc "Get the current user"
  #  field :category, list_of(:category) do
  #    resolve &CategoryResolver.list_categories/3
  #  end
  #end

  object :category do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :books, list_of(:books)
  end

  object :books do
    field :isbn, non_null(:string)
    field :title, non_null(:string)
    field :price, :decimal
    field :authors, list_of(:author)
    field :category, :category
  end

  object :reader do
    field :id, non_null(:id)
    field :name, :string
    field :email, :string
    field :isbn, :string
  end

  # query do
  #   @desc """
  #   Retrieves a specific User entity based on their unique ID.

  #   This query can access a complete set of user details which
  #   includes all relevant fields and associations.
  #   """
  #   field :user, :user do
  #     arg(:id, non_null(:id), description: "The unique ID of the user")
  #     resolve(&UserResolver.user/3)
  #   end
  # end
end
