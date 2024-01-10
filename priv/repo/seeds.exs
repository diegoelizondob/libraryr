# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Libraryr.Repo.insert!(%Libraryr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Libraryr.Library.{Book, Author, Category, Reader}
alias Libraryr.Repo

# Create Category
# Libraryr.Library.create_category(%{"name" => "test category"})

# Create Books
# Libraryr.Library.create_book(%{"isbn" => "testuniqueisbn", "title" => "Book1", "category_id" => 2, "authors" => [%{name: "Sofia", birthday: "sofias-bday"}, %{name: "Ricardo", birthday: "rics-bday"}]})

# Update Books
# Libraryr.Library.update_book("testuniqueisbn", %{"isbn" => "testuniqueisbn", "title" => "Bookunique", "category_id" => 3, "authors" => [%{name: "Sofiaupdated", birthday: "sofias-bday"}, %{name: "Ricardoupdated", birthday: "rics-bdasyyyy"}]})

# Delete Books
# Libraryr.Library.delete_book("test2isbn")

# Read Books
# Libraryr.Library.get_book_with_authors!("testuniqueisbn")

# Read Books
# Libraryr.Library.list_books()

# Read Categories
# Libraryr.Library.list_cetegories()

# Category SEEDS
%Category{
  name: "Horror"
} |> Repo.insert!

%Category{
  name: "Drama"
} |> Repo.insert!

%Category{
  name: "Action"
} |> Repo.insert!

%Category{
  name: "Fiction"
} |> Repo.insert!

# Book SEEDS
%Book{
  isbn: "testisbn",
  title: "Book1",
  authors: [
    %Author{name: "Sofia", birthday: "24-08-1992"},
    %Author{name: "Ricardo", birthday: "13-11-1991"}
  ],
  category_id: 2,
  price: 32
} |> Repo.insert!

%Book{
  isbn: "test2isbn",
  title: "Book2",
  authors: [
    %Author{name: "Juan", birthday: "23-09-1989"},
    %Author{name: "John", birthday: "01-11-1976"}
  ],
  category_id: 1,
  price: 156
} |> Repo.insert!

%Reader{
  name: "Mariaa",
  email: "maria.garza@mail.com",
  isbn: "testisbn"
} |> Repo.insert!

# %Reader{
#   name: "Mariaa OTro",
#   email: "maria.garza@maail.com",
#   isbn: "testisbn2"
# } |> Repo.insert!

# ---------- ERROR (same authors)! -----------
# %Book{
#   isbn: "test3isbn",
#   title: "Book1 part 2",
#   authors: [
#     %Author{name: "Sofia", birthday: "24-08-1992"},
#     %Author{name: "Ricardo", birthday: "13-11-1991"}
#   ],
#   price: 949
# } |> Repo.insert!
