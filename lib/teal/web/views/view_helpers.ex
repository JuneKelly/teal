defmodule Teal.Web.ViewHelpers do
  def site_name do
    Application.get_env(:teal, :site_name)
  end
end
