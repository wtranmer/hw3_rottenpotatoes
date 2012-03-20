# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  ndx1 = page.body.index(e1)
  ndx2 = page.body.index(e2)
  assert ndx1 != nil, "#{e1} not found in \n#{page.body}"
  assert ndx2 != nil, "#{e2} not found in \n#{page.body}"
  assert ndx1 < ndx2, "#{e1} is not before #{e2} in \n#{page.body}"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(',')
  ratings.each do |field|
    step %{I #{uncheck}check "ratings_#{field.strip}"}
  end
  click_button("ratings_submit")
end
Then /^(?:|I )should see all the movies$/ do 
  @all_movies = Movie.all

  @all_movies.each do |movie|
    step %{I should see "#{movie.title}"}
  end

end

