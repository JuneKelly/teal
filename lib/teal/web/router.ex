defmodule Teal.Web.Router do
  use Teal.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Teal.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/d/:slug", PageController, :show_document_by_slug
    post "/document", PageController, :create_document
  end

  # Other scopes may use custom stacks.
  # scope "/api", Teal.Web do
  #   pipe_through :api
  # end
end
