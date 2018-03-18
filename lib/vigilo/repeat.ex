defmodule Vigilo.Repeat do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :attendant)
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

  def handle_call(:devices, _from, state) do
    { :reply, state, state }
  end

  defp schedule() do
    Process.send_after(self(), :work, 1000 * 30) # every 30 sec
  end
end
