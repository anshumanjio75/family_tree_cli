defmodule FamilyTree.CLI do
  use ExCLI.DSL
  alias FamilyTree.CLIInputs
  alias FamilyTree.Storage

  def main(_var) do
    Storage.main()
    ExCLI.run!(FamilyTree.CLI)
  end

  name("family-tree")
  description("family tree cli")
  option(:verbose, count: true, aliases: [:v])

  command :add do
    description(
      "Add person or relationship -- ./family-tree add person <name> or ./family-tree add relationship <name>"
    )

    argument(:type, default: "")
    argument(:first_name, default: "")
    argument(:last_name, default: "", list: true)

    run context do
      CLIInputs.process_add_command(context)
      |> Storage.add_person_or_relationship()
    end
  end

  command :connect do
    description(
      "Connect persons with relationship -- ./family-tree connect <name 1> as <relationship> of <name 2>"
    )

    argument(:first_name1, default: "")
    argument(:last_name1, default: "")
    argument(:as, default: "")
    argument(:relationship, default: "")
    argument(:in, default: "")
    argument(:law, default: "")
    argument(:of, default: "")
    argument(:first_name2, default: "")
    argument(:last_name2, default: "", list: true)

    run context do
      CLIInputs.process_connect_command(context)
      |> Storage.add_connection()
    end
  end

  command :count do
    description("Count number of relationship -- ./family-tree count sons of <name>")

    argument(:relationship, default: "")
    argument(:in, default: "")
    argument(:law, default: "")
    argument(:of, default: "")
    argument(:first_name, default: "")
    argument(:last_name, default: "", list: true)

    run context do
      CLIInputs.process_count_command(context)
      |> get_response()
      |> List.flatten()
      |> Enum.count()
      |> IO.inspect(label: "count")
    end
  end

  command :relationship do
    aliases(Storage.get_realtionship_aliases())
    description("Find relationship person name -- ./family-tree father of <name>")

    argument(:of, default: "")
    argument(:first_name, default: "")
    argument(:last_name, default: "", list: true)

    run context do
      {[relationship | _], full_name} =
        {System.argv(), "#{context[:first_name]}#{context[:last_name]}"}

      get_response({relationship, full_name})
      |> List.flatten()
      |> Enum.join(", ")
      |> IO.inspect(label: "name")
    end
  end

  def get_response({relationship, full_name}) do
    case String.split(relationship, "grand") do
      [relationship | []] ->
        {relationship, full_name}
        |> Storage.get_select_query()

      [_ | [relationship | []]] ->
        {relationship, full_name}
        |> Storage.get_select_query()
        |> Enum.map(fn name ->
          {relationship, name}
          |> Storage.get_select_query()
        end)
    end
  end
end
