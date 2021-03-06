#!/usr/bin/env ruby
require 'json'
require 'uri'
require 'net/http'
require 'fileutils'


def pull(endpoint)
    filename = 'site-configuration.json'
    if File.file?(filename)
        file = File.read(filename)
    else
        file = File.read("#{filename}.example")
    end
    conf = JSON.parse(file)
    uri = URI("#{conf['webservice_address']}/api/#{endpoint}")
    req = Net::HTTP::Get.new(uri, initheader = {'Content-Type' =>'application/json'})
    req.body = {user: {email: conf['email'], password: conf['password']}}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
    end

    FileUtils.mkdir_p('local-json')
    File.open("local-json/#{endpoint}.json", 'w') { |file| file.write(res.body) }
end

pull('customer_users')
pull('products')
pull('vendors')
