class Year < ActiveRecord::Base
  has_many :bookmarks, -> {order(:bookmarked_at)}

  def volume_number_based_on_start_year(start_year)
    year_string.to_i - start_year.to_i + 1
  end  
end

class Bookmark < ActiveRecord::Base
  belongs_to :year

  def tags
    if raw_tags
      raw_tags.split(" ")
    else
      []
    end
  end
  
  def year
    bookmarked_at.strftime('%Y')
  end

  def month
    bookmarked_at.strftime('%B')
  end

  def day
    bookmarked_at.strftime("%d")
  end

  def qr_for_url
    "http://qrcode.kaywa.com/img.php?s=8&d=#{CGI.escape(href)}"
  end

  def self.start_year
    order("bookmarked_at").first.year
  end
end
