defmodule Vigilo.Attendance do
  @moduledoc """
  Perform the logic of the attendance check. Read the status of the bluetooth
  scan to see who's around.
  """

  def take_attendance() do
    read() |> parse() |> filter()
  end

  def read() do
    case System.cmd("hcitool", []) do
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
end
