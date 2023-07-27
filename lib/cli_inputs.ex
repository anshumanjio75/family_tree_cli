defmodule FamilyTree.CLIInputs do
  def process_add_command(context) do
    cond do
      # ./family-tree add anshuman
      context[:first_name] == "" && context[:last_name] == "" && context[:type] != "relationship" ->
        type = "person"
        first_name = context[:type]
        last_name = ""
        IO.puts("name: #{first_name} #{last_name} - type: #{type}")
        {type, "#{first_name}#{last_name}"}

      # ./family-tree add amit kumar
      context[:type] not in ["person", "relationship"] && context[:last_name] == "" ->
        type = "person"
        {first_name, last_name} = {context[:type], context[:first_name]}
        IO.puts("name: #{first_name} #{last_name} - type: #{type}")
        {type, "#{first_name}#{last_name}"}

      # ./family-tree add person sunny kumar
      true ->
        IO.puts("name: #{context.first_name} #{context.last_name} - type: #{context.type}")
        {context.type, "#{context.first_name}#{context.last_name}"}
    end
  end

  def process_connect_command(context) do
    cond do
      # ./family-tree connect Raju as son in law of KK Pathak
      context[:last_name1] == "as" && context[:relationship] == "in" ->
        last_name1 = ""

        {relationship, first_name2, last_name2} =
          {context[:as] <> context[:relationship] <> context[:in], context[:of],
           context[:first_name2]}

        IO.puts(
          "Connected #{context.first_name1} #{last_name1} as #{relationship} in law of #{first_name2} #{last_name2}"
        )

        {"#{context.first_name1}#{last_name1}", relationship, "#{first_name2}#{last_name2}"}

      # ./family-tree connect Dhakad as son of KK Pathak
      context[:last_name1] == "as" && context[:relationship] == "of" ->
        last_name1 = ""
        {relationship, first_name2, last_name2} = {context[:as], context[:in], context[:law]}

        IO.puts(
          "Connected #{context.first_name1} #{last_name1} as #{relationship} of #{first_name2} #{last_name2}"
        )

        {"#{context.first_name1}#{last_name1}", relationship, "#{first_name2}#{last_name2}"}

      # ./family-tree connect Dhakad Kumar as son of KK Pathak
      context[:as] == "as" && context[:in] == "of" ->
        last_name1 = context[:last_name1]

        {relationship, first_name2, last_name2} =
          {context[:relationship], context[:law], context[:of]}

        IO.puts(
          "Connected #{context.first_name1} #{last_name1} as #{relationship} of #{first_name2} #{last_name2}"
        )

        {"#{context.first_name1}#{last_name1}", relationship, "#{first_name2}#{last_name2}"}

      # ./family-tree connect Raju Kumar as son in law of KK Pathak
      true ->
        IO.puts(
          "Connected #{context.first_name1} #{context.last_name1} as #{context.relationship} #{context.in} #{context.law} of #{context.first_name2} #{context.last_name2}"
        )

        {"#{context.first_name1}#{context.last_name1}",
         "#{context.relationship}#{context.in}#{context.law}",
         "#{context.first_name2}#{context.last_name2}"}
    end
  end

  def process_count_command(context) do
    cond do
      # ./family-tree count sons of Raju
      context[:in] == "of" ->
        {first_name, last_name} = {context[:law], context[:of]}
        IO.puts("count: #{first_name} #{last_name} - relationship: #{context[:relationship]}")
        {context[:relationship], "#{first_name}#{last_name}"}

      # ./family-tree count sons in law of Raju kumar
      true ->
        IO.puts(
          "count: #{context[:first_name]} #{context[:last_name]} - relationship: #{context[:relationship]} #{context[:in]} #{context[:law]}"
        )

        {"#{context[:relationship]}#{context[:in]}#{context[:law]}}",
         "#{context[:first_name]}#{context[:last_name]}"}
    end
  end
end
