defmodule FamilyTree.Model.Connection do
  use Memento.Table,
    attributes: [:first_person, :relationship, :second_person]
end
