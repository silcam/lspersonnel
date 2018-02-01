class User < ApplicationRecord

  enum language: { en: 0 , fr: 1 }

  def toggle_language
    language == "en" ? fr! : en!
  end

end
