defmodule Csv do
  use Application

  @impl true
  def start(_type, args) do
    Csv.Supervisor.start_link(args)
  end
end
