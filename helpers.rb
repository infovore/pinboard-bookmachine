helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def format_date(date)
    date.strftime("%d %B %Y")
  end

  def mark_hash(string)
    Digest::MD5.hexdigest(string)
  end

  def id_for_tag(tag_string, previous_tags_array)
    if previous_tags_array.include?(tag_string)
      previous_tags_array << tag_string
      count = previous_tags_array.count(tag_string)
      ["#{tag_string}-#{count}",previous_tags_array]
    else
      previous_tags_array << tag_string
      ["#{tag_string}-1", previous_tags_array]
    end
  end
end

