require 'test_helper'

class IPTest < Minitest::Test
  include FlutterWaveTestHelper

  attr_reader :client, :ip, :response_data, :url

  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
    @ip = Faker::Internet.ip_v4_address
  end

  def sample_check_body
    {
      ip: ip
    }
  end

  def sample_check_response
    {
      'data' => {
        'responsecode' => '00',
        'ipaddress' => ip,
        'alpha2code' => Faker::Address.country_code,
        'alpha3code' => Faker::Address.country_code << 'X',
        'responsemessage' => Faker::Lorem.sentence,
        'country_name' => Faker::Address.country,
        'transactionreference' => "FLW#{Faker::Number.number(8)}"
      },
      'status' => 'success'
    }
  end

  def test_check
    @response_data = sample_check_response
    @url = Flutterwave::Utils::Constants::IP[:check_url]

    stub_flutterwave

    response = client.ip.check(sample_check_body)
    assert response.successful?
  end
end
