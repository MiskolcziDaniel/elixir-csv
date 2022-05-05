defmodule Csv.Server do
  use GenServer

  # Client API

  def max_mass(pid) do
    GenServer.call(pid, :max_mass)
  end

  def avg_height(pid, :female) do
    GenServer.call(pid, {:avg_height, :female})
  end

  def avg_height(pid, :male) do
    GenServer.call(pid, {:avg_height, :male})
  end

  def distribution_by_age(pid) do
    GenServer.call(pid, :distribution_by_age)
  end

  # Server API

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def handle_call(:max_mass, _from, state) do
    {name, mass} = Csv.Csvparse.max_mass()
    {:reply, "The heaviest is #{name}, with #{mass}!", state}
  end

  @impl true
  def handle_call({:avg_height, :female}, _from, state) do
    avg = Csv.Csvparse.avg_height("female")
    {:reply, "The average height among females is #{avg}!", state}
  end

  @impl true
  def handle_call({:avg_height, :male}, _from, state) do
    avg = Csv.Csvparse.avg_height("male")
    {:reply, "The average height among males is #{avg}!", state}
  end

  @impl true
  def handle_call(:distribution_by_age, _from, state) do
    stats = Csv.Csvparse.distribution_by_age()
    {:reply, stats, state}
  end
end
