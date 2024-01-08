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

alias Libraryr.Library.{Book, Author}
alias Libraryr.Repo

# Create func
# Libraryr.Library.create_book(%{"isbn" => "testisbfffn", "title" => "Book1", "authors" => [%{name: "Sofia", birthday: "sofias-bday"}, %{name: "Ricardo", birthday: "rics-bday"}]})

# Delete func
# Libraryr.Library.delete_book("testisbfffn")

# SEEDS
%Book{
  isbn: "testisbn",
  title: "Book1",
  authors: [
    %Author{name: "Sofia", birthday: "24-08-1992"},
    %Author{name: "Ricardo", birthday: "13-11-1991"}
  ],
  price: 32
} |> Repo.insert!

%Book{
  isbn: "test2isbn",
  title: "Book2",
  authors: [
    %Author{name: "Juan", birthday: "23-09-1989"},
    %Author{name: "John", birthday: "01-11-1976"}
  ],
  price: 156
} |> Repo.insert!

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
