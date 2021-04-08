namespace :dev do

	PASSWORD = 123456
	ADMIN = 'admin@admin.com'
	USER = 'user@user.com'
	DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')


	desc "Configura o ambiente de desenvolvimento"
	task setup: :environment do
		if Rails.env.development?
			show_spinner("Apagando BD...") { %x(rails db:drop) }
			show_spinner("Criando BD...") { %x(rails db:create) }
			show_spinner("Migrando BD...") { %x(rails db:migrate) }
			show_spinner("Criando o Administrador padrão...") { %x(rails dev:add_default_admin) }
			show_spinner("Criando Administradores extras...") { %x(rails dev:add_extra_admins) }
			show_spinner("Criando o Usuário padrão...") { %x(rails dev:add_default_user) }
			show_spinner("Criando Assuntos padrões...") { %x(rails dev:add_subjects) }
			show_spinner("Criando Perguntas e Respostas padrões...") { %x(rails dev:add_answers_and_quests) }
		else
			puts "Você não está em ambiente de desenvolvimento!"
		end
	end

	desc "Adiciona o administrador padrão"
	task add_default_admin: :environment do
		Admin.create!(
			email: ADMIN,
			password: PASSWORD,
			password_confirmation: PASSWORD
		)
	end

	desc "Adiciona um administrador extra"
	task add_extra_admins: :environment do
		10.times do |i|
			Admin.create!(
				email: Faker::Internet.email,
				password: PASSWORD,
				password_confirmation: PASSWORD
			)
		end
	end

	desc "Adiciona o usuário padrão"
	task add_default_user: :environment do
		User.create!(
			email: USER,
			password: PASSWORD,
			password_confirmation: PASSWORD
		)
	end

	desc "Adiciona assuntos padrão"
	task add_subjects: :environment do
		file_name = 'subjects.txt'
		file_path = File.join(DEFAULT_FILES_PATH, file_name)

		File.open(file_path, 'r').each do |line|
			Subject.create!(description: line.strip)
		end
	end

	desc "Adiciona Perguntas e Respostas padrões"
	task add_answers_and_quests: :environment do
		Subject.all.each do |subject|
			rand(5..10).times do |i|
				params = create_question_params(subject)
				answers_array = params[:question][:answers_attributes]
				# Adiciona as respostas
				add_answer(answers_array)
				# Elege uma resposta verdadeira
				elect_correct_answer(answers_array)
				# Cria a questão no BD
				Question.create!(params[:question])
			end
		end
	end

	desc "Reseta o contador dos assuntos"
	task reset_subject_counter: :environment do
		show_spinner("Resetando contador dos assuntos...") do
			Subject.find_each do |subject|
				Subject.reset_counters(subject.id, :questions)
			end
		end
	end

	private

	desc "Mostra o Spinner no terminal"
	def show_spinner(msg_start, msg_end = "Concluído!")
		spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
		spinner.auto_spin
		yield
		spinner.success("(#{msg_end})")
	end

	desc "Cria uma questão"
	def create_question_params(subject=Subject.all.sample)
		{question: {
			description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}", 
			subject: subject,
			answers_attributes: []
		}}
	end

	def create_answer_params(correct = false)
		{description: Faker::Lorem.sentence, correct: correct}
	end

	def add_answer(array=[])
		rand(2..5).times do |j|
			array.push(
				create_answer_params
			)
		end
	end

	def elect_correct_answer(array = [])
		selected_index = rand(array.size)
		array[selected_index] = create_answer_params(true)
	end
end
