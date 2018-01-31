defmodule VigiloWeb.PageController do
  use VigiloWeb, :controller

  def index(conn, _params) do
    devs = GenServer.call(:attendant, :devices)
    render conn, "index.html", devices: devs
  end
end
