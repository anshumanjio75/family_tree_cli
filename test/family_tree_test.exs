defmodule FamilyTreeTest do
  use ExUnit.Case
  alias FamilyTree.Storage

  Storage.main()

  test "add person" do
    Memento.start()
    Process.sleep(1000)
    assert :ok = ExCLI.run(FamilyTree.CLI, ["add", "person", "Anshuman"])
  end

  test "add relationship" do
    Memento.start()
    Process.sleep(1000)
    assert :ok = ExCLI.run(FamilyTree.CLI, ["add", "relationship", "son"])
  end

  test "count relationship" do
    Memento.start()
    Process.sleep(1000)
    assert 1 = ExCLI.run(FamilyTree.CLI, ["count", "sons", "of", "KK", "Dhakad"])
  end

  test "find relationship" do
    Memento.start()
    Process.sleep(1000)
    assert "" = ExCLI.run(FamilyTree.CLI, ["son", "of", "KK", "Dhakad"])
  end

  test "connect by relationship" do
    Memento.start()
    Process.sleep(1000)

    assert :ok =
             ExCLI.run(FamilyTree.CLI, [
               "connect",
               "Amit",
               "Dhakad",
               "as",
               "son",
               "of",
               "KK",
               "Dhakad"
             ])
  end
end
