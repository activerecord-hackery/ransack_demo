module UsersHelper

  def present_results(count)
  	if count > 10
  		"Your first 10 results out of #{count} total"
  	else
  		"Your #{pluralize(count, 'result')}"
  	end
  end

end
