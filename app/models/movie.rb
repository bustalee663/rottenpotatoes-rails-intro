class Movie < ActiveRecord::Base
    Movie.select(:rating).map(&:rating).uniq
end
