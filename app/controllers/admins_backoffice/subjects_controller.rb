class AdminsBackoffice::SubjectsController < AdminsBackofficeController
	before_action :set_subject, only: [:edit, :update, :destroy]
	before_action :set_subjects, only: [:index]

	def index; end

	def edit; end

	def new
		@subject = Subject.new
	end

	def create
		@subject = Subject.new(params_subject)
		if @subject.save
			redirect_to admins_backoffice_subjects_path, notice: "Assunto cadastrado!!!"
		else
			render :new
		end
	end

	def update
		if @subject.update(params_subject)
			redirect_to admins_backoffice_subjects_path, notice: "Assunto atualizado!!!"
		else
			render :edit
		end
	end

	def destroy
		if @subject.destroy
			redirect_to admins_backoffice_subjects_path, notice: "Assunto excluído!!!"
		else
			render :index
		end
	end

	private

	def params_subject
		params.require(:subject).permit(:description)
	end

	def set_subject
		@subject = Subject.find(params[:id])
	end

	def set_subjects
		@subjects = Subject.all.order(:id).page(params[:page])
		# @subjects = Subject.all.page(params[:page]).per(5) # Quantidade de subjects por pagina
	end
end
