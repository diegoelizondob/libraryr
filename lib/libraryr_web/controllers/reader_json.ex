defmodule LibraryrWeb.ReaderJSON do
  alias Libraryr.Library.Reader

  @doc """
  Renders a list of readers.
  """
  def index(%{readers: readers}) do
    %{data: for(reader <- readers, do: data(reader))}
  end

  @doc """
  Renders a single reader.
  """
  def show(%{reader: reader}) do
    %{data: data(reader)}
  end

  defp data(%Reader{} = reader) do
    %{
      id: reader.id,
      name: reader.name,
      email: reader.email
    }
  end
end
