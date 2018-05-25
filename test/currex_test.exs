defmodule CurrexTest do
  use ExUnit.Case
  doctest Currex

  test "fetches rates in USD" do
    in_usd_latest = Currex.latest!("USD")
    assert %{rates: _, timestamp: _} = in_usd_latest
    assert %{currency: _, timestamp: _, rate: _} = hd(in_usd_latest.rates)
  end
end
