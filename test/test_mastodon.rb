require "minitest/autorun"
require_relative "../lib/mastodon"

class AccountTest < Minitest::Test
  def test_account_has_id
    account = Mastodon::Account.new({"id" => 1})
    assert_equal 1, account.id
  end
end

class StatusTest < Minitest::Test
  def test_status_has_id
    status = Mastodon::Status.new({"id" => 1})
    assert_equal 1, status.id
  end
end

class CardTest < Minitest::Test
  def test_card_has_url
    card = Mastodon::Card.new({"id" => 1, "url" => "https://example.com"})
    assert_equal card.url, "https://example.com"
  end
end
