defmodule RaftDemo.Lock do
  use Raft.StateMachine

  @type lock :: :locked
              | :unlocked

  def start_link(name) do
    Raft.start_link(__MODULE__, name: name)
  end

  @spec init(Raft.peer()) :: {:ok, lock()}
  def init(_name) do
    {:ok, {:unlocked, nil}}
  end

  def handle_write({:lock, client}, {:unlocked, nil}) do
    {:ok, {:locked, client}}
  end
  def handle_write({:lock, client}, {:locked, client}) do
    {:ok, {:locked, client}}
  end
  def handle_write({:lock, client}, {:locked, other_client}) do
    {:error, {:locked, other_client}}
  end

  def handle_write({:unlock, client}, {:locked, client}) do
    {:ok, {:unlocked, nil}}
  end
  def handle_write({:unlock, client}, {:locked, other_client}) do
    {:error, {:locked, other_client}}
  end
end
