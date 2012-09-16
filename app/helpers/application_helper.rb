module ApplicationHelper
  def slice_by_length(str, str_length)
    str.split(//).first(str_length).inject("") do |result, char|
      result += char
    end
  end
end
