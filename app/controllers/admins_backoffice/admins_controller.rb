class AdminsBackoffice::AdminsController < AdminsBackofficeController
	before_action :verify_password, only: [:update]
	before_action :set_admin, only: [:edit, :update, :destroy]
	before_action :set_admins, only: [:index]

	def index; end

	def edit; end

	def new
		@admin = Admin.new
	end

	def create
		@admin = Admin.new(params_admin)
		if @admin.save
			redirect_to admins_backoffice_admins_path, notice: "Administrador cadastrado!!!"
		else
			render :new
		end
	end

	def update
		if @admin.update(params_admin)
			AdminMailer.update_email(current_admin, @admin).deliver_now
			redirect_to admins_backoffice_admins_path, notice: "Administrador atualizado!!!"
		else
			render :edit
		end
	end

	def destroy
		if @admin.destroy
			redirect_to admins_backoffice_admins_path, notice: "Administrador excluído!!!"
		else
			render :index
		end
	end

	private

	def params_admin
		params.require(:admin).permit(:email, :password, :password_confirmation)
	end

	def set_admin
		@admin = Admin.find(params[:id])
	end

	def set_admins
		@admins = Admin.all.page(params[:page])
		# @admins = Admin.all.page(params[:page]).per(5) # Quantidade de admins por pagina
	end

	def verify_password
		if params[:admin][:password].blank? && params[:admin][:password_confirmation].blank?
			params[:admin].extract!(:password, :password_confirmation)
		end
	end
end
