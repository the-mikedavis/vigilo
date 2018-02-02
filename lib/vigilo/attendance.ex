defmodule Vigilo.Attendance do
  require Logger
  @moduledoc """
  Perform the logic of the attendance check. Read the status of the bluetooth
  scan to see who's around.
  """

  def take_attendance() do
    att = read() |> parse() |> filter()
    Logger.info "Scan found: #{format(att)}"
    att
  end

  def read() do
    case System.cmd("hcitool", ["scan"]) do
      { response, 0 } ->
        response
      { error,    _ } ->
        exit "hcitool (bluetooth) reported an error: " <> error
    end
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
  end

  # no results found
  def filter([ _ ]), do: []
  # found at least one result
  def filter([ _searching | found ]) do
    Enum.map(found, fn f ->
      [ mac, name ] = Regex.split(~r{\s+}, f)
      %Vigilo.Person{name: name, mac: mac}
    end)
  end

  def format([]), do: "nothing."
  def format(maps) do
    maps
    |> Enum.map(fn %{name: name, mac: addr} ->
      "Device '#{name}' with address #{addr}"
    end)
    |> Enum.join(", ")
  end
end
