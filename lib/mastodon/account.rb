module Mastodon
  class Account
    attr_reader :raw_data

    def initialize(data)
      @raw_data = data
    end

    def id
      @raw_data.fetch('id')
    end
  end
end
