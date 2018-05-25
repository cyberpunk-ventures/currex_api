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
