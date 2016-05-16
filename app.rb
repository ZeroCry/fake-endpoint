require 'sinatra'
require 'uri'
require 'json'


get '*' do
  uri = URI.parse(request.env["REQUEST_URI"]) 
  json_response_as_string = File.read("#{Dir.getwd}#{uri.path}")
  json_response = parse_json_template(uri.query, json_response_as_string)
  return  json_response
end

post '*' do 
  uri = URI.parse(request.env["REQUEST_URI"]) 
  
  json_response_as_string = File.read("#{Dir.getwd}#{uri.path}")
  request.params.each do |k, v|
    reg_exp_match = "<TAG*>(.*?)</TAG>".gsub("TAG", k)   
    json_response_as_string.gsub!(%r[#{reg_exp_match}], v.to_s)  
  end
  json_response_as_string.gsub!(/<(.*?)*>/, '')  
  return  json_response_as_string
end


def parse_json_template(query, json_template)  
  query.to_s.split("&").each do |param|
    k, v = param.split("=") 
    reg_exp_match = "<TAG*>(.*?)</TAG>".gsub("TAG", k)   
    json_template.gsub!(%r[#{reg_exp_match}], v.to_s)  
  end 
  return json_template
end