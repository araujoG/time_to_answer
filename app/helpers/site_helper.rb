module SiteHelper
	def page_title
		case params[:action]
		when "index"
			"Últimas perguntas cadastradas..."
		when "questions"
			"Resultados para o termo: '#{params[:term]}'"
		when "subject"
			"Perguntas sobre '#{params[:subject]}"
		end
	end
end
