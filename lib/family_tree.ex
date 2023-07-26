defmodule FamilyTree.CLI do
  use ExCLI.DSL

  name("family_tree_cli")
  description("family tree cli")
  option(:verbose, count: true, aliases: [:v])

  command :add do
    description("Add person or relationship")

    argument :type
    argument :first_name, default: ""
    argument :last_name, default: ""

    run context do
      cond  do
        context[:first_name] == "" && context[:last_name] == "" ->
          type = "person"
          first_name = context[:type]
          last_name = ""
          IO.puts("name: #{first_name} #{last_name} - type: #{type}")

        context[:type] not in ["person", "relationship"] && context[:last_name] == "" ->
          type = "person"
          first_name = context[:type]
          last_name = context[:first_name]
          IO.puts("name: #{first_name} #{last_name} - type: #{type}")

        true ->
          IO.puts("name: #{context.first_name} #{context.last_name} - type: #{context.type}")
      end
    end
  end

  command :connect do
    description("connect persons with relationship")

    argument :first_name1
    argument :last_name1
    argument :as
    argument :relationship
    argument :of
    argument :first_name2, default: ""
    argument :last_name2, default: ""

    run context do
      cond  do
        context[:last_name1] == "as" ->
          last_name1 = ""
          relationship = context[:as]
          first_name2 = context[:of]
          last_name2 = context[:first_name2]
          IO.puts("Connected #{context.first_name1} #{last_name1} as #{relationship} of #{first_name2} #{last_name2}")
        true ->
          IO.puts("Connected #{context.first_name1} #{context.last_name1} as #{context.relationship} of #{context.first_name2} #{context.last_name2}")
      end
    end
  end

  def main(var) do
    ExCLI.run!(FamilyTree.CLI)
  end
end
