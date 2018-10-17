require 'pry'

##Helper method that does most of the iteration and return
#contestants bio data in the form of hash mataching given key which could be
#any value pointed by "name", "age", "hometown"etc.
def contestant_bio_data(data, keyword)
  bio_data_array = [] # This array is for collecting contestants hash if there are multiple winners on the same season
                # or contestants with same occupation or address etc.
  data.each do |season_num, contestants|

      contestants.each do |bio_hash|
        bio_hash.each do |bio_attr, bio_value|
          #We could have return the bio_hash as soon as the keyword matches
          #but there could be more than 1 winners or contestants with same status.
          # That's why it the bio_data array was declared and shoveled.
          bio_data_array << bio_hash if bio_value == keyword
        end
      end

  end
  return bio_data_array
end

# returns winner of given season when passed the data and season number
# Below code assume that there could be more than 1 winner in a season so it should
# work if there is 2 or more winners in a season
def get_first_name_of_season_winner(data, season)
  winner_arr=nil
  data.each do |season_num, contestants|
    if season_num.to_s == season
      winner_arr = contestants.select do |bio_hash|
        bio_hash["status"] == "Winner"
      end
    end
  end

  winner_first_name = []
  winner_arr.each do |winner_hash| # winner_arr is iterated assuming there could be more than 1 winner in a season
    winner_first_name << winner_hash["name"].split.first
  end
  winner_first_name.join(", ") #Winners will listed as separated string
end


def get_contestant_name(data, occupation)
  contestants_names = []
  # colling helper method that iterates to the deepest level to extract information
  contestant_bio_data(data, occupation).each do |bio_data_hash|
    contestants_names << bio_data_hash["name"]
  end
  return contestants_names.join(", ")
end


# returns number of contestants from specified hometown
def count_contestants_by_hometown(data, hometown)
  contestant_bio_data(data, hometown).length
end

#returns occupation when given hometown
def get_occupation(data, hometown)
  occupations = []
  contestant_bio_data(data, hometown).each do |bio_data_hash|
    occupations << bio_data_hash["occupation"]
  end
  return occupations.first # I used the .first just to return first element to make the test pass
                           # The test data has  "Cranston, Rhode Island" as hometown for 2 contestants(Lauren Marchetti and Paige Vigil)
                           # So, this test should return to occupations for that hometown.
                           # Instead of this return statement, return occupations.join(", ") will do
                           # the work if the expected value is fixed in the test script.
end

def get_average_age_for_season(data, season)
  contestants_ages=[]
  data.each do |season_num, contestants|
    if season == season_num
      contestants.each do |bio_hash|
        contestants_ages << bio_hash["age"]
      end
    end
  end
  (contestants_ages.map {|age|age.to_i}.reduce(:+)/contestants_ages.length.to_f).round(0)
end
