require 'octokit'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'pry'


FRONT_END_LIST = JSON.parse(File.read('data/front-end.json'))
BACK_END_LIST  = JSON.parse(File.read('data/back-end.json'))

# ('') -> ''
def get_github_profile(url)
  page = Nokogiri::HTML(URI.open(url))
  links = page.css('a').map { |link| link['href']}
  profiles = links.select { |l| l.match(/^https:\/\/github.com\//) }
  profiles.first.split('/').last
end

# ('') -> [{}]
def get_repositories_for(user)
  client = Octokit::Client.new
  repos = client.repos(user, query: { type: 'owner', sort: 'asc' })

  repos.map do |repo|
   json = Faraday.get("https://api.github.com/repos/#{user}/#{repo.name}/languages").body
   JSON.parse(json)
  end
end

 # ([{}]) -> []
 def to_list(languages)
  nonempty = languages.select { |repo| !repo.empty? }
  nonempty.map { |h| h.keys }
 end

# ([], {}) -> {}
def categorize(languages, results={})
 return results if languages.empty?

 if results.empty?
  results = {
   :frontend => [],
   :backend => [],
   :fullstack => []
  }
 end

 repo = languages.shift
 frontend  = repo & FRONT_END_LIST
 backend   = repo & BACK_END_LIST
 fullstack = (!frontend.empty? && !backend.empty?)

 if fullstack
  results[:fullstack] << repo
 elsif !frontend.empty?
  results[:frontend] << repo
 else
  results[:backend] << repo
 end
 categorize(languages, results)
end

# ({}) -> []
def calculate_percentages(categories)
 counts = {}
 categories.keys.each do |k|
  counts.store(k, categories[k].count)
 end

 total = counts.values.reduce(0) { |c, sum| c + sum }

 percentages = {}
 counts.keys.each do |k|
  pct = ((categories[k].count.to_f / total) * 100).round
  percentages.store(k, pct)
 end
 percentages
end

