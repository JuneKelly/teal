defmodule Teal.Web.PageController do
  use Teal.Web, :controller
  alias Teal.Core.Document
  alias Teal.Repo
  alias Teal.RateLimiter
  require Logger

  plug :rate_limit, %{name: "create_document", max_requests: 10, interval_seconds: 60} when action in [:create_document]

  def index(conn, _params) do
    Logger.log :info, "rendering index page"
    changeset = Document.changeset(%Document{})
    render conn, "index.html", changeset: changeset
  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def show_document_by_slug(conn, %{"slug" => slug}) do
    Logger.log :info, "Showing document '#{slug}'"
    case Repo.get_by(Document, slug: slug) do
      nil ->
        conn
        |> put_status(404)
        |> render("404.html")
      document ->
        case Earmark.as_html(document.md_content) do
          {:ok, html, []} ->
            render conn, "document.html", document: document, document_html: html
          _ ->
            Logger.log :warn, "Document '#{slug}' is not valid markdown"
            conn
            |> put_flash(:error, "Error, invalid document")
            |> redirect(to: page_path(conn, :index))
        end
    end
  end

  def create_document(conn, %{"document" => document_params}) do
    slug = :crypto.rand_bytes(9) |> Base.url_encode64
    Logger.log :info, "Creating document '#{slug}'"
    document_params = Map.put(document_params, "slug", slug)
    changeset = Document.changeset(%Document{}, document_params)
    rerender_with_error = fn ->
      conn
      |> put_flash(:error, "Error, invalid document")
      |> render("index.html", changeset: changeset)
    end
    case Earmark.as_html(document_params["md_content"]) do
      {:ok, _html, []} ->
        case Repo.insert(changeset) do
          {:ok, document} ->
            Logger.log :info, "Created document '#{slug}'"
            conn
            |> put_flash(:info, "Created document")
            |> redirect(to: page_path(conn, :show_document_by_slug, document.slug))
          {:error, changeset} ->
            Logger.log :warn, "Could not insert document"
            rerender_with_error.()
        end
      _ ->
        Logger.log :warn, "Submitted document is not valid markdown"
        rerender_with_error.()
    end
  end

  def rate_limit(conn, options \\ %{}) do
    limiter_name = options[:name]
    interval_ms = options[:interval_seconds] * 1000
    max_requests = options[:max_requests]
    ip = conn.remote_ip |> Tuple.to_list |> Enum.join(".")
    bucket_name = "#{limiter_name}:#{ip}"
    case ExRated.check_rate(bucket_name, interval_ms, max_requests) do
      {:ok, _count} ->
        conn
      {:error, _count} ->
        conn
        |> put_status(:forbidden)
        |> render("rate_limit.html")
        |> halt()
    end
  end

end
