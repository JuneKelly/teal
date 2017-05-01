defmodule Teal.Web.PageController do
  use Teal.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
