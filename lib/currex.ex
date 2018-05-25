defmodule Currex do
  @moduledoc """
  Documentation for Currex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Currex.hello
      :world

  """
  use Tesla

  plug(Tesla.Middleware.FollowRedirects)
  plug(Tesla.Middleware.BaseUrl, "https://api.currex.info/json/latest")
  plug(Tesla.Middleware.JSON)

  def latest!(currency) do
    {:ok, tesla_env} = get("/#{currency}/")
    body = tesla_env.body

    %{
      timestamp: DateTime.from_unix!(body["timestamp"]) |> DateTime.to_naive(),
      rates: Enum.map(body["rates"], &AtomicMap.convert(&1, %{safe: false}))
    }
  end

end
