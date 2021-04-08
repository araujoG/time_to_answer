module UsersBackoffice::ProfileHelper
	def gender_select(user, current_gender)
		if user.user_profile.gender == current_gender
			"btn-primary"
		else
			"btn-default"
		end
	end
end
