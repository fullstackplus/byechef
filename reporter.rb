require_relative 'byechef'

def report(url)
 username = get_github_profile('https://fullstackplus.tech/')
 calculated = calculate_percentages(
     categorize(
      to_list(
       get_repositories_for(username)
      )
     )
    )

 puts "----------------------------------------"
 puts "#{username} is: "
 puts "\b"
 puts "#{calculated[:frontend]}% frontend"
 puts "#{calculated[:backend]}% backend"
 puts "#{calculated[:fullstack]}% full-stack"
 puts "----------------------------------------"
end

report('https://fullstackplus.tech/')
