defmodule FamilyTree.Model.Relationship do
  use Memento.Table,
    attributes: [:fullname, :gender]
end
