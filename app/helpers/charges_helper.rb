module ChargesHelper
  def format_curr(num)
    sprintf('%.2f', num)
  end

  def round_or_blank(num)
    num.nil? ? '' : num.round(6)
  end

  def month_to_date
    [strftime('%c', ),strftime('%c', )]
  end
end