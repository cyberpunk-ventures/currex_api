defmodule Currex do
  use Tesla

  @moduledoc """
  Documentation for Currex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Currex.hello
      :world

  """

  plug(Tesla.Middleware.FollowRedirects)
  plug(Tesla.Middleware.BaseUrl, "https://api.currex.info/json/latest")
  plug(Tesla.Middleware.JSON)

  @doc """
  Use currency ticker (like USD or EUR) to get multiple base currencies rates in a given quote currency
  """
  def latest!(currency) do
    {:ok, tesla_env} = get("/#{currency}/")
    body = tesla_env.body
    rates = body["rates"]
    timestamp = body["timestamp"]

    %{
      timestamp: DateTime.from_unix!(timestamp) |> DateTime.to_naive(),
      rates:
        Enum.map(rates, fn datum when is_map(datum) ->
          datum
          |> AtomicMap.convert(%{safe: false})
          |> Map.update!(:timestamp, fn timestamp ->
            DateTime.from_unix!(timestamp) |> DateTime.to_naive()
          end)
        end)
    }
  end
end
