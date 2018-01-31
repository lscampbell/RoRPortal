class ChargePageLink
  attr_accessor :intro_text, :link_text, :url

  def initialize(intro_text, link_text, url)
    self.intro_text = intro_text
    self.link_text = link_text
    self.url = url
  end
end