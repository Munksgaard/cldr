require Cldr.Backend
require Cldr.Locale.Loader
require MyApp.Gettext

defmodule MyApp.Cldr do
  use Cldr,
    gettext: MyApp.Gettext,
    locales: ["en", "en-001", "de", "ja", "en-AU", "th", "ar", "pl", "doi", "fr-CA", "nb", "no", "ca-ES-VALENCIA", "ca"],
    generate_docs: true,
    providers: []

    def for_dialyzer do
      {:ok, _} = Cldr.put_locale("en")
      {:ok, _} = Cldr.put_locale(:en)
    end
end
