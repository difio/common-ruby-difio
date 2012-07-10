require "common-ruby-difio/version"
require "bundler"
require 'net/http'
require 'net/https'
require 'json'

module Difio
	class DifioBase
		@@difio_url = "https://difio-otb.rhcloud.com/application/register/"
		@@post_data = {
		  'user_id' => nil,
		  'app_name' => nil,
		  'app_uuid' => nil,
		  'app_type' => 'Ruby',
		  'app_url'  => nil,
		  'app_vendor' => nil,
		  'pkg_type' => 1,
		  'installed' => [],
		}	
	
		def self.configure(options)
			if options['url']
				@@difio_url = options['url']
			end
			@@post_data.each do |k,v|
				@@post_data[k] = options[k] if options[k]
			end
		end
	
		def get_module_list()
			Bundler.load.lock
			gems = []
			Bundler.load.specs.each do |g|
				gems << {'n' => g.name, 'v' => "#{g.version}#{g.git_version}" }
			end
			return gems
		end
	
		def get_deps_as_json(gems=nil)
			data  = @@post_data.clone()
			data['installed'] = gems || get_module_list()
			return JSON.dump(data)
		end
	
		def post_to_difio()
			gems = get_module_list()
			json = get_deps_as_json(gems)
			this_module = vendor_module = nil
			gems.each do |m|
				if m['n'] == "common-ruby-difio"
					this_module = m['n'] + '/' + m['v']
				end
				if m['n'] =~ /difio-(.*?)-ruby/
					vendor_module = m['n'] + '/' + m['v']
				end
			end
			headers = {
				'User-Agent' =>  vendor_module + ' ' + this_module
			}			
			uri = URI(@@difio_url)
			req = Net::HTTP::Post.new(uri.path,headers)
			req.set_form_data({ 'json_data' => json})
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true
			#http.set_debug_output $stderr
			res = http.start do |h|
				h.request(req)
			end

			res
		end
	
		def cli()
			if ARGV.include? '--printJSON'
				puts get_deps_as_json()
				exit
			end
			result = post_to_difio()
			case result
			when Net::HTTPSuccess
				puts "difio: #{result.body}"
			else
				puts "difio: #{result.code} #{result.message}"
			end
		end
	end
end
