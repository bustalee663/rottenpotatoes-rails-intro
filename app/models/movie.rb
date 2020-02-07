class Movie < ActiveRecord::Base
    def self.ratings
		movie_array = []
		#https://stackoverflow.com/questions/27791553/rails-correct-way-of-turning-activerecord-relation-to-array

		#Read in the unique ratings
		all_ratings = Movie.select(:rating).distinct.to_a

		#Get them to strings
		for item in all_ratings
			movie_array.push item.rating.to_s
		end

		#Sort for UI prettyness
		movie_array.sort!
	end
end
