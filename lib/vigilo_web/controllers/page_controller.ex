defmodule VigiloWeb.PageController do
  use VigiloWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
