defmodule FamilyTree.Storage do
  alias FamilyTree.Model.Person
  alias FamilyTree.Model.Relationship
  alias FamilyTree.Model.Connection

  def main(_) do
    nodes = [node()]
    path = Application.get_env(:mnesia, :dir)

    if !File.exists?(path) do
      :ok = File.mkdir_p!(path)

      Memento.stop()
      Memento.Schema.create(nodes)
      Memento.Schema.set_storage_type(node(), :disc_only_copies)
      Memento.start()
      Memento.Table.create!(Person, disc_only_copies: nodes)
      Memento.Table.create!(Relationship, disc_only_copies: nodes)
      Memento.Table.create!(Connection, disc_only_copies: nodes)
    else
      # Memento.add_nodes(nodes)
      # Memento.info()
    end
  end

  def get_counting({relationship, full_name}) do
    guards = [
      {:==, :second_person, full_name},
      {:==, :relationship, relationship |> String.trim_trailing("s")}
    ]

    Memento.Transaction.execute_sync!(fn ->
      Memento.Query.all(Connection)
      |> print_connections()

      Memento.Query.select(Connection, guards)
      |> Enum.count()
    end)
  end

  def get_all_relationships() do
    Memento.start()

    Memento.Transaction.execute_sync!(fn ->
      Memento.Query.all(Relationship)
      |> Enum.map(& &1.fullname)
      |> Enum.reduce([], fn x, acc -> [x, x <> "s"] ++ acc end)
      |> Enum.reverse()
      |> IO.inspect(label: "Relationship")
    end)
  end

  def get_person_name({relationship, full_name}) do
    guards = [
      {:==, :second_person, full_name},
      {:==, :relationship, relationship |> String.trim_trailing("s")}
    ]

    Memento.Transaction.execute_sync!(fn ->
      Memento.Query.all(Connection)
      |> print_connections()

      Memento.Query.select(Connection, guards)
      |> Enum.map(& &1.first_person)
      |> Enum.join(", ")
    end)
  end

  def add_person_or_relationship({type, full_name}) do
    case type do
      "relationship" ->
        Memento.Transaction.execute_sync!(fn ->
          Memento.Query.write(%Relationship{fullname: full_name, gender: ""})

          Memento.Query.all(Relationship)
          |> Enum.map(& &1.fullname)
          |> Enum.join(", ")
          |> IO.inspect(label: "Relationships")
        end)

      _ ->
        Memento.Transaction.execute_sync!(fn ->
          Memento.Query.write(%Person{fullname: full_name, gender: ""})

          Memento.Query.all(Person)
          |> Enum.map(& &1.fullname)
          |> Enum.join(", ")
          |> IO.inspect(label: "Persons")
        end)
    end

    Memento.stop()
  end

  def add_connection({first_name, relationship, second_name}) do
    Memento.Transaction.execute_sync!(fn ->
      Memento.Query.write(%Connection{
        first_person: first_name,
        relationship: relationship,
        second_person: second_name
      })

      Memento.Query.write(%Connection{
        first_person: second_name,
        relationship: inverse(relationship, second_name),
        second_person: first_name
      })

      Memento.Query.all(Connection)
      |> print_connections()
    end)

    Memento.stop()
  end

  defp inverse(relationship, _second_name) do
    case relationship do
      "father" -> "son"
      "son" -> "father"
      "husband" -> "wife"
      "wife" -> "husband"
      "mother" -> "daughter"
      "daughter" -> "mother"
    end
  end

  defp print_connections(connections) do
    connections
    |> Enum.map(&"#{&1.first_person} -- #{&1.relationship} -- #{&1.second_person}")
    |> Enum.join(", ")
    |> IO.inspect(label: "Connections")
  end
end
