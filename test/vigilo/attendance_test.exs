defmodule Vigilo.AttendanceTest do
  use ExUnit.Case
  alias Vigilo.Attendance

  @expected_input "Searching...\n\tA   B\n\tC   D\n"

  test "parsing the input works on expected input" do
    assert Attendance.parse(@expected_input) == ["Searching...", "A   B", "C   D"]
  end

  test "filtering the input from parse works as expected" do
    assert Attendance.filter(["Searching...", "A   B", "C   D"]) == [
      %Vigilo.Person{mac: "A", name: "B"}, %Vigilo.Person{mac: "C", name: "D"}
    ]
  end
end
