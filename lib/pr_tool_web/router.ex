defmodule PrToolWeb.Router do
  use PrToolWeb, :router

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

  # Other scopes may use custom stacks.
  scope "/api", PrToolWeb do
    pipe_through :api

    resources "/git_repos", GitRepoController, except: [:new, :edit] do
      resources "/pull_requests", PullRequestController, only: [:index, :show]
    end

    post "/git_repos/:id/reload", GitRepoController, :reload
  end

  scope "/", PrToolWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
