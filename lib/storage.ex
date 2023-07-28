defmodule FamilyTree.Storage do
  alias FamilyTree.Model.Person
  alias FamilyTree.Model.Relationship
  alias FamilyTree.Model.Connection

  def main() do
    nodes = [node()]
    path = Application.get_env(:mnesia, :dir)

    if !File.exists?(path) do
      File.mkdir_p!(path)
      Memento.stop()
      Memento.Schema.create(nodes)
      Memento.start()
      Memento.Table.create!(Person, disc_copies: nodes)
      Memento.Table.create!(Relationship, disc_copies: nodes)
      Memento.Table.create!(Connection, disc_copies: nodes)
    end
  end

  def get_counting({relationship, full_name}) do
    Memento.Transaction.execute_sync!(fn ->
      Memento.Query.all(Connection)
      |> print_connections()

      Memento.Query.select(Connection, get_select_query({relationship, full_name}))
      |> Enum.count()
    end)
  end

  def get_person_name({relationship, full_name}) do
    Memento.Transaction.execute_sync!(fn ->
      Memento.Query.all(Connection)
      |> print_connections()

      Memento.Query.select(Connection, get_select_query({relationship, full_name}))
      |> Enum.map(& &1.first_person)
      |> Enum.join(", ")
    end)
  end

  defp get_select_query({relationship, full_name}) do
    relationship = relationship |> String.trim_trailing("s")

    if relationship == "children" do
      {:and, {:==, :second_person, full_name},
       {:or, {:==, :relationship, "son"}, {:==, :relationship, "daughter"}}}
    else
      [
        {:==, :second_person, full_name},
        {:==, :relationship, relationship}
      ]
    end
  end

  def add_person_or_relationship({type, full_name}) do
    case type do
      "relationship" ->
        Memento.Transaction.execute_sync!(fn ->
          Memento.Query.write(%Relationship{
            fullname: full_name,
            gender: get_relationship_gender(full_name)
          })

          Memento.Query.all(Relationship)
          |> print_names()
          |> IO.inspect(label: "Relationships")
        end)

      _ ->
        Memento.Transaction.execute_sync!(fn ->
          Memento.Query.write(%Person{fullname: full_name, gender: ""})

          Memento.Query.all(Person)
          |> print_names()
          |> IO.inspect(label: "Persons")
        end)
    end

    Memento.stop()
  end

  def add_connection({first_name, relationship, second_name}) do
    Memento.Transaction.execute_sync!(fn ->
      all_connections = Memento.Query.all(Connection)

      if is_nil(is_duplicate_connection(all_connections, {first_name, relationship, second_name})) do
        Memento.Query.write(%Connection{
          first_person: first_name,
          relationship: relationship,
          second_person: second_name
        })

        Memento.Query.write(%Person{
          fullname: first_name,
          gender: get_relationship_gender(relationship)
        })
      end

      if is_nil(
           is_duplicate_connection(
             all_connections,
             {second_name, inverse(relationship, second_name), first_name}
           )
         ) and
           not is_nil(inverse(relationship, second_name)) do
        Memento.Query.write(%Connection{
          first_person: second_name,
          relationship: inverse(relationship, second_name),
          second_person: first_name
        })

        Memento.Query.write(%Person{
          fullname: second_name,
          gender: get_relationship_gender(inverse(relationship, second_name))
        })
      end

      Memento.Query.all(Connection)
      |> print_connections()
    end)

    Memento.stop()
  end

  defp is_duplicate_connection(all_connections, {first_person, relationship, second_person}) do
    all_connections
    |> Enum.find(
      &(&1.first_person == first_person && &1.relationship == relationship &&
          &1.second_person == second_person)
    )
  end

  def get_realtionship_aliases() do
    [
      :father,
      :mother,
      :son,
      :sons,
      :daughter,
      :daughters,
      :wife,
      :husband,
      :brother,
      :brothers,
      :sister,
      :sisters,
      :childrens,
      :children
    ]
  end

  defp get_relationship_gender(name) do
    case name do
      "father" -> "m"
      "son" -> "m"
      "husband" -> "m"
      "wife" -> "f"
      "mother" -> "f"
      "daughter" -> "f"
      "brother" -> "m"
      "sister" -> "f"
      _ -> ""
    end
  end

  defp inverse(relationship, name) do
    case {relationship, if(p = Memento.Query.read(Person, name), do: p.gender)} do
      {"father", "m"} -> "son"
      {"father", "f"} -> "daughter"
      {"son", "m"} -> "father"
      {"son", "f"} -> "mother"
      {"husband", _} -> "wife"
      {"wife", _} -> "husband"
      {"mother", "m"} -> "son"
      {"mother", "f"} -> "daughter"
      {"daughter", "m"} -> "father"
      {"daughter", "f"} -> "mother"
      {"brother", "m"} -> "brother"
      {"brother", "f"} -> "sister"
      {"sister", "m"} -> "brother"
      {"sister", "f"} -> "sister"
      _ -> nil
    end
  end

  defp print_connections(connections) do
    connections
    |> Enum.map(&"#{&1.first_person} -- #{&1.relationship} -- #{&1.second_person}")
    |> Enum.join(", ")
    |> IO.inspect(label: "Connections")
  end

  defp print_names(schema) do
    schema
    |> Enum.map(& &1.fullname)
    |> Enum.join(", ")
  end
end
