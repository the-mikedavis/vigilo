defmodule Vigilo.Repeat do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  # should be [] to start with
  def init(state) do
    schedule()
    { :ok, state }
  end

  def handle_info(:work, _state) do
    schedule()
    { :noreply, Vigilo.Attendance.take_attendance() }
  end

  defp schedule() do
    Process.send_after(self(), :work, 1000 * 10)
  end
end
