defmodule Vigilo.Repeat do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_) do
    schedule()
    { :ok, [] }
  end

  def handle_info(:work, state) do
    # do work
    schedule()
    { :noreply, state }
  end

  defp schedule() do
    Process.send_after(self(), :work, 1000 * 10)
  end
end
