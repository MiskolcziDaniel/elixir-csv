defmodule Csv.Csvparse do
  @moduledoc """
  Documentation for `Learning`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Learning.hello()
      :world

  """
  def read_csv do
    CSV.decode!(File.stream!("characters.csv"), headers: true, separator: ?;)
  end

  def max_mass do
    read_csv()
    |> Enum.reject(fn %{"mass" => mass} -> mass == "NA" end)
    |> Enum.map(fn %{"name" => name, "mass" => mass} -> {name, to_number(mass)} end)
    |> Enum.max_by(fn {_name, mass} -> mass end)
  end

  def avg_height(gender_param) do
    rows =
      read_csv()
      |> Enum.filter(fn %{"gender" => gender} -> gender == gender_param end)
      |> Enum.reject(fn %{"height" => height} -> height == "NA" end)
      |> Enum.map(fn %{"height" => height} -> to_number(height) end)

    Float.round(Enum.sum(rows) / Enum.count(rows), 2)
  end

  def distribution_by_age do
    default = %{
      "female" => %{
        "above 40" => 0,
        "below 21" => 0,
        "unknown" => 0
      },
      "male" => %{
        "above 40" => 0,
        "below 21" => 0,
        "between 21 and 40" => 0,
        "unknown" => 0
      },
      "other" => %{
        "above 40" => 0,
        "below 21" => 0,
        "between 21 and 40" => 0,
        "unknown" => 0
      }
    }

    read_csv()
    |> Enum.map(fn %{"gender" => gender, "birth_year" => birth_year} ->
      %{"gender" => gender, "birth_year" => birth_year}
    end)
    |> Enum.reduce(default, fn %{"gender" => gender, "birth_year" => birth_year}, acc ->
      gender = partition_by_gender(gender)
      age = partition_by_age(birth_year)

      update_in(acc[gender][age], &(&1 + 1))
    end)
  end

  defp partition_by_gender(gender) do
    case gender do
      "female" -> "female"
      "male" -> "male"
      _ -> "other"
    end
  end

  defp partition_by_age(age) do
    parsed_age =
      case String.ends_with?(age, "BBY") do
        true -> String.trim_trailing(age, "BBY") |> to_number
        false -> age
      end

    case parsed_age do
      x when is_number(x) and 0 < x and x < 21 -> "below 21"
      x when is_number(x) and x >= 21 and x < 40 -> "between 21 and 40"
      x when is_number(x) and x >= 40 -> "above 40"
      _ -> "unknown"
    end
  end

  defp to_number(item) do
    case Float.parse(item) do
      {num, ""} -> num
      _ -> false
    end
  end
end
