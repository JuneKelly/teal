defmodule Teal.Web.PageController do
  use Teal.Web, :controller
  alias Teal.Core.Document
  alias Teal.Repo

  def index(conn, _params) do
    changeset = Document.changeset(%Document{})
    render conn, "index.html", changeset: changeset
  end

  def show_document_by_slug(conn, %{"slug" => slug}) do
    case Repo.get_by(Document, slug: slug) do
      nil ->
        conn
        |> put_status(404)
        |> render("404.html")
      document ->
        case Earmark.as_html(document.md_content) do
          {:ok, html} ->
            render conn, "document.html", document_html: html
          _ ->
            conn
            |> put_flash(:error, "Error, invalid document")
            |> redirect(to: page_path(:index))
        end
    end
  end

  def create_document(conn, %{"document" => document_params}) do
    slug = :crypto.rand_bytes(9) |> Base.url_encode64
    document_params = Map.put(document_params, "slug", slug)
    changeset = Document.changeset(%Document{}, document_params)
    case Repo.insert(changeset) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Created document")
        |> redirect(to: page_path(conn, :show_document_by_slug, document.slug))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error, invalid document")
        |> render("index.html", changeset: changeset)
    end
  end

end
