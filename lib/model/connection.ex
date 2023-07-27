defmodule FamilyTree.Model.Connection do
  use Memento.Table,
    attributes: [:id, :first_person, :relationship, :second_person],
    type: :ordered_set,
    autoincrement: true
end
