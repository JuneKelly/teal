defmodule Teal.Web.PageController do
  use Teal.Web, :controller
  alias Teal.Core.Document

  def index(conn, _params) do
    changeset = Document.changeset(%Document{})
    render conn, "index.html", changeset: changeset
  end

  def show_document_by_slug(conn, %{"slug" => slug}) do
    render conn, "document.html", document_html: "<h1>Test</h1>"
  end

  def create_document(conn, _params) do
  end
end
