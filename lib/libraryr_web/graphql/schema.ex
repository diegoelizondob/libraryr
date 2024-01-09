defmodule LibraryWeb.GraphQL.Schema do
  @moduledoc """
  The Absinthe schema for the application.
  """
  use Absinthe.Schema
  alias Library.Resolver.CategoryResolver

  query do
    @desc "Get the current user"
    field :category, list_of(:category) do
      resolve &CategoryResolver.list_categories/3
    end
  end

  object :category do
    field :id, non_null(:id)
    field :name, non_null(:string)
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
