module UsersBackofficeHelper
	def avatar_url
		avatar = current_user.user_profile.avatar
		if avatar.attached?
			avatar
		else
			"defaultAvatar.png"
		end
	end
end
