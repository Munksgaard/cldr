defmodule Cldr.Config.Dependents do
  @moduledoc false

  defp known_providers do
    %{
      Cldr.Number    => {Cldr.Number.Backend, :define_number_modules},
      Cldr.Currency  => {Cldr.Currency.Backend, :define_currency_module},
      Cldr.DateTime  => {Cldr.DateTime.Backend, :define_date_time_modules},
      Cldr.List      => {Cldr.List.Backend, :define_list_module},
      Cldr.Unit      => {Cldr.Unit.Backend, :define_unit_module},
      Cldr.Territory => {Cldr.Territory.Backend, :define_territory_module}
    }
  end

  defp known_provider_modules do
    known_providers()
    |> Map.keys
  end

  @provider_fun_name :cldr_backend_provider

  # For compatibility with the releases that don't configure
  # Reconsider this.
  def cldr_provider_modules(%Cldr.Config{providers: nil, backend: backend} = config) do
    IO.warn("No Cldr provider modules were configured under the :providers " <>
    "key in backend module #{inspect backend}. " <>
    "Attempting to configure known Cldr providers.")

    cldr_provider_modules(%{config | providers: known_provider_modules()})
  end

  def cldr_provider_modules(%Cldr.Config{providers: providers} = config) when is_list(providers) do
    for provider_module <- providers do
      if mf = Map.get(known_providers(), provider_module) do
        {m, f} = mf
        {m, f, [config]}
      else
        {provider_module, @provider_fun_name, [config]}
      end
    end
  end

  def cldr_provider_modules(%Cldr.Config{providers: providers, backend: backend}) do
    raise ArgumentError, "The config key :providers should be a list of " <>
    "module names that are called at compile time. " <>
    "Found #{inspect providers} in backend #{inspect backend}"
  end

end
