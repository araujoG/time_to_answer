class Site::WelcomeController < SiteController
	def index
		@questions = Question.lastQuestions(params[:page])
		@user_statistic = UserStatistic.find_or_create_by(user: current_user)
	end
end
