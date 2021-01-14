require 'date'
require 'json'
require 'cgi'

class Meeting
	def start_up
		puts "\n"
		puts '1. New Meeting'
		puts '2. Edit Meeting'
		puts '3. View Meeting'
		puts '4. View Meeting for a participants'
		puts '5. Cancel Meeting'
		puts '6. Delete Meeting'

		print "\nPlease select an option: "
		main_menu = gets.chomp.to_i
		
		case main_menu
		when 1
			create_meeting
		when 2
			edit_meeting
		when 3
			view_meeting
		when 4
			view_meeting
		when 5
			cancel_meeting
		when 6
			delete_meeting
		else
			start_up
		end

	end

	def create_meeting
		print("\nType (Video, Phone & In-Person): ")
		type = gets.chomp
		print("Date (DD/MM/YYYY): ")
		date = gets.chomp
		print("Time (HH:MM): ")
		time = gets.chomp
		print("Title: ")
		title = gets.chomp
		print("Created by: ")
		create_by = gets.chomp
		print("Participant: ")
		participant = gets.chomp
		print("Meeting link: ")
		meeting_link = gets.chomp

		@data_array = []
		file = File.read('data.json')
		if file.length != 0
			data_hash = JSON.parse(file)
			data_hash.each do |d|
				@data_array.push(d)
			end
			create_id = @data_array.length + 1;
		else
			create_id = 1;
		end

		tempHash = {
			'id': create_id,
			'title': title,
			'type': 'Video',
			'date': Time.now.strftime('%d/%m/%Y'),
			'time': Time.now.strftime('%H:%M %p'),
			'created_by': create_by,
			'participant': participant,
			'meeting_link': meeting_link,
			'status': 'Active'
		}
		@data_array.push(tempHash)
		
		File.open("data.json", "w") do |f|
			f.write(@data_array.to_json)
		end

		sleep(1)
		puts "\nSaving data..."
		sleep(2)
		puts "Sending email to #{participant}"
		sleep(2)
		start_up
	end

	def edit_meeting
		@new_array = []
		file = File.read('data.json')
		data_hash = JSON.parse(file)
		puts("___________________________________________________________________________________________________")
		puts("ID\tTitle\t\tCreated by\t\tStatus")
		puts("___________________________________________________________________________________________________")

		i = 0
		while i < data_hash.length do
			puts("#{data_hash[i]['id']}\t#{data_hash[i]['title']}\t#{data_hash[i]['created_by']}\t#{data_hash[i]['status']}") if data_hash[i]['status'] != 'Delete'
			i += 1
		end 

		print "\nSelect an meeting Id for edit: "
		edit_id = gets.chomp.to_i
		update_id = edit_id - 1

		print("Title: ")
		edit_title = gets.chomp
		print("Type: ")
		edit_type = gets.chomp
		print("Date (DD/MM/YYYY): ")
		edit_date = gets.chomp
		print("Time (HH:MM): ")
		edit_time = gets.chomp

		print("Do you want to send notifications to participants (y/n): ")
		send_mail = gets.chomp

		data_hash.each do |d|
			@new_array.push(d)
		end
		@new_array[update_id]['title'] = edit_title
		@new_array[update_id]['type'] = edit_type
		@new_array[update_id]['date'] = edit_date
		@new_array[update_id]['time'] = edit_time

		File.open("data.json", "w") do |f|
			f.write(@new_array.to_json)
		end

		sleep(1)
		puts 'updating data...'
		sleep(2)
		puts 'Skipping email notification to participants.' if send_mail == 'n'
		puts 'Sending email notification to participants.' if send_mail == 'y'
		start_up
	end

	def view_meeting
		file = File.read('data.json')
		data_hash = JSON.parse(file)

		puts('________________________________________________________')
		puts("ID\tTitle\t\tCreated by\t\tStatus")
		puts('________________________________________________________')

		i = 0
		while i < data_hash.length do
			puts("#{data_hash[i]['id']}\t#{data_hash[i]['title']}\t#{data_hash[i]['created_by']}\t#{data_hash[i]['status']}") if data_hash[i]['status'] != 'Delete'
			i += 1
		end
		
		print "\nSelect an meeting Id for View: "
		view_id = gets.chomp.to_i

		puts "\nID\t\t: #{data_hash[view_id - 1]['id']}"
		puts "Title\t\t: #{data_hash[view_id - 1]['title']}"
		puts "Type\t\t: #{data_hash[view_id - 1]['type']}"
		puts "Date\t\t: #{data_hash[view_id - 1]['date']}"
		puts "Time\t\t: #{data_hash[view_id - 1]['time']}"
		puts "Created by\t: #{data_hash[view_id - 1]['created_by']}"
		puts "Participant\t: #{data_hash[view_id - 1]['participant']}"
		puts "Meeting link\t: #{data_hash[view_id - 1]['meeting_link']}"
		puts "Status\t\t: #{data_hash[view_id - 1]['status']}"

		puts "\n"
		start_up
	end

	def cancel_meeting
		update_status = update_meeting('Cancel')
		start_up
	end

	def delete_meeting
		update_status = update_meeting('Delete')
		start_up
	end

	def update_meeting(status)
		@new_array = []
		file = File.read('data.json')
		data_hash = JSON.parse(file)

		puts('___________________________________________________________________________________________________')
		puts("ID\tTitle\t\tCreated by\t\tStatus")
		puts('___________________________________________________________________________________________________')

		i = 0
		while i < data_hash.length do
			puts("#{data_hash[i]['id']}\t#{data_hash[i]['title']}\t#{data_hash[i]['created_by']}\t#{data_hash[i]['status']}") if data_hash[i]['status'] != 'Delete'
			i += 1
		end

		print "\nSelect an meeting Id for #{status}: "
		status_id = gets.chomp.to_i
		update_id = status_id - 1

		data_hash.each do |d|
			@new_array.push(d)
		end
		@new_array[update_id]['status'] = 'Cancel' if status == 'Cancel'
		@new_array[update_id]['status'] = 'Delete' if status == 'Delete'

		File.open("data.json", "w") do |f|
			f.write(@new_array.to_json)
		end
		return true
	end
end

Meeting.new.start_up
