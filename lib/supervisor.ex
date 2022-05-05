defmodule Csv.Supervisor do
  use Supervisor

  @impl true
  def init(opts) do
    children = [
      Csv.Server
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, name: __MODULE__)
  end
end
