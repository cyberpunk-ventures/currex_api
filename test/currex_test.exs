defmodule CurrexTest do
  use ExUnit.Case
  doctest Currex

  test "fetches rates in USD" do
    in_usd_latest = Currex.latest!("USD")
    assert %{rates: _, timestamp: global_timestamp} = in_usd_latest
    assert NaiveDateTime.to_iso8601(global_timestamp) |> NaiveDateTime.from_iso8601!() == global_timestamp
    assert %{currency: _, timestamp: timestamp, rate: _} = hd(in_usd_latest.rates)
    assert NaiveDateTime.to_iso8601(timestamp) |> NaiveDateTime.from_iso8601!(  ) == timestamp
  end
end
