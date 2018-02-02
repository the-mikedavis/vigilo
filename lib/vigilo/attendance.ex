defmodule Vigilo.Attendance do
  require Logger
  @moduledoc """
  Perform the logic of the attendance check. Read the status of the bluetooth
  scan to see who's around.
  """

  defp pmap(seq, func) do
    seq
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&(Task.await(&1, 10 * 1000)))
  end

  def take_attendance() do
    att = Application.get_env(:vigilo, :macs)
          |> pmap(&take_attendance/1)   # run in parallel because it's expensive
          |> Enum.filter(&filter/1)
    Logger.info "Scan found: #{format(att)}"
    att
  end

  def take_attendance(mac) do
    mac |> read() |> parse()
  end

  def read(mac) do
    case System.cmd("hcitool", ["name", mac]) do
      { response, 0 } ->
        { String.trim(response), mac }  # remove trailing newline
      { error,    _ } ->
        exit "hcitool (bluetooth) reported an error: " <> error
    end
  end

  # not present
  def parse({"", mac}) do
    %Vigilo.Person{mac: mac, present: false}
  end
  # present
  def parse({name, mac}) do
    %Vigilo.Person{mac: mac, name: name, present: true}
  end

  def filter(%{present: here}), do: here

  def format([]), do: "nothing."
  def format(maps) do
    maps
    |> Enum.map(fn %{name: name, mac: addr} ->
      "Device '#{name}' with address #{addr}"
    end)
    |> Enum.join(", ")
  end
end
