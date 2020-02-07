class Movie < ActiveRecord::Base
    Movie.select(:rating).distinct.inject([]){ |a, m| a.push m rating}
end
