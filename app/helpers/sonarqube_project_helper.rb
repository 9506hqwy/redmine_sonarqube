# frozen_string_literal: true

module SonarqubeProjectHelper
  def humanize1000(value)
    val = value&.to_d
    return if val.nil?

    if val < 1000
      value
    elsif val < (1000 * 1000)
      "#{(val / 1000).round(2)} K"
    else
      "#{(val / 1000 / 1000).round(2)} M"
    end
  end

  def val_or_default(value, default='-')
    value.presence || default
  end
end
