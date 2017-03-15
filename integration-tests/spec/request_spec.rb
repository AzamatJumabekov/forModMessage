require './console-app/sender.rb'
require 'json'
require 'pry'

RSpec.describe Sender do
  it 'should return rendered text from template' do
   params = {"template": "SMSOTP_kz", "to": "+95745732234", "params": {"code": "4353"}}
   json = JSON.generate(params)
   request = Sender.new
   a = request.send(json)
   expect(a.kind_of? Net::HTTPSuccess).to eq(true)
 end

  it 'should return missing params' do
   params = {"template": "SMSOTP_kz", "to": "+95745732234"}
   json = JSON.generate(params)
   request = Sender.new
   a = request.send(json)
   hash = JSON.parse(a.body)
   expect(hash['error'].first).to eq({"code"=>"params_missing", "params"=>["code"]})
 end
end