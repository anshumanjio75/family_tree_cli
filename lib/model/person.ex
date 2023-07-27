defmodule FamilyTree.Model.Person do
  use Memento.Table,
    attributes: [:fullname, :gender]
end
