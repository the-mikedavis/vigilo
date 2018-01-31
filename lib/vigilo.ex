defmodule Vigilo do
  @moduledoc """
  Vigilo keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmodule Person do
    defstruct name: "", mac: ""
  end
end
