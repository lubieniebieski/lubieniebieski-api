module Mastodon
  class Status
    attr_reader :raw_data

    def initialize(data)
      @raw_data = data
    end

    def id
      @raw_data.fetch('id')
    end

    def created_at
      @raw_data.fetch('created_at')
    end

    def content
      @raw_data.fetch('content')
    end

    def account
      Account.new @raw_data.fetch('id')
    end

    def reblog
      return if @raw_data.fetch('reblog').nil?

      self.class.new(@raw_data.fetch('reblog'))
    end

    def card
      return if @raw_data.fetch('card').nil?

      Card.new(@raw_data.fetch('card'))
    end
  end
end
