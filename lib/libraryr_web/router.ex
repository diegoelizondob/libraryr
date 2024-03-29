defmodule LibraryrWeb.Router do
  use LibraryrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LibraryrWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug :accepts, ["json"]
  end

  scope "/", LibraryrWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/authors", AuthorController
    resources "/books", BookController
    resources "/categories", CategoryController
  end

  # Other scopes may use custom stacks.
  scope "/api", LibraryrWeb do
    pipe_through :api
    resources "/categories", CategoryController, except: [:new, :edit]
  end

  scope "/graphql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: LibraryWeb.GraphQL.Schema
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:libraryr, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LibraryrWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end

    forward "/dev/graphiql", Absinthe.Plug.GraphiQL,
      schema: LibraryWeb.GraphQL.Schema,
      interface: :playground
  end
end
