defmodule PayCosern.Gleam do
  @moduledoc """
  This module exists to create a smooth interoperability between Elixir and Gleam.
  """

  @doc """
  This function validates the structure of a bill. 
  """
  @spec validate_structure(map :: map()) :: {String.t(), map()}
  def validate_structure(map) do
    :pay_cosern.validate_bill_structure(map)
  end
end
