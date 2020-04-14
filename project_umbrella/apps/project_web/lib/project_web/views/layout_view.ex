defmodule ProjectWeb.LayoutView do
  use ProjectWeb, :view

  def new_locale(conn, locale, language_title) do
    "<a href='#{conn.request_path}?locale=#{locale}'>#{language_title}</a>" |> raw
  end
end