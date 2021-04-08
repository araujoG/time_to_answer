class AdminsBackoffice::QuestionsController < AdminsBackofficeController
	before_action :set_question, only: [:edit, :update, :destroy]
	before_action :set_questions, only: [:index]
	before_action :set_subjects, only: [:edit, :new]

	def index; end

	def edit; end

	def new
		@question = Question.new
	end

	def create
		@question = Question.new(params_question)
		if @question.save
			redirect_to admins_backoffice_questions_path, notice: "Questão cadastrada!!!"
		else
			render :new
		end
	end

	def update
		if @question.update(params_question)
			redirect_to admins_backoffice_questions_path, notice: "Questão atualizada!!!"
		else
			render :edit
		end
	end

	def destroy
		if @question.destroy
			redirect_to admins_backoffice_questions_path, notice: "Questão excluída!!!"
		else
			render :index
		end
	end

	private

	def params_question
		params.require(:question).permit(:description, :subject_id, answers_attributes: [:id, :description, :correct, :_destroy])
	end

	def set_question
		@question = Question.find(params[:id])
	end

	def set_questions
		@questions = Question.includes(:subject).order(:description).page(params[:page])
		# @questions = question.all.page(params[:page]).per(5) # Quantidade de questions por pagina
	end

	def set_subjects
		@subjects = Subject.all
		# @questions = question.all.page(params[:page]).per(5) # Quantidade de questions por pagina
	end
end
