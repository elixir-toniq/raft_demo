defmodule RaftDemoTest do
  use ExUnit.Case
  doctest RaftDemo

  test "example" do
    Raft.start_peer(Demo.Lock, name: :s1)
    Raft.start_peer(Demo.Lock, name: :s2)
    Raft.start_peer(Demo.Lock, name: :s3)
    Raft.set_configuration(:s1, [:s1, :s2, :s3])

    :ok    = Raft.write(:s1, {:lock, :s1})
    :error = Raft.write(:s2, {:lock, :s2})
    :error = Raft.write(:s2, {:unlock, :s2})
    :ok    = Raft.write(:s1, {:unlock, :s1})
    :ok    = Raft.write(:s2, {:lock, :s2})
  end
end
