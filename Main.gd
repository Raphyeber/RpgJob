extends Control

var jobs = []  # menyimpan data dari CSV

func _ready():
	load_csv_data()
	populate_dropdown()

func load_csv_data():
	var file = FileAccess.open("res://resource/class.csv", FileAccess.READ)
	if file:
		file.get_line()  
		while not file.eof_reached():
			var line = file.get_line().strip_edges()  # hilangkan spasi kosong di awal/akhir
			if line == "":  # Abaikan baris kosong
				continue
			var columns = line.split(",")
			if columns.size() < 4:  # Validasi jumlah kolom
				push_error("Invalid row format in CSV: " + line)
				continue
			var job = {
				"id": int(columns[0]),
				"name": columns[1],
				"description": columns[2],
				"skills": columns[3].split(";")
			}
			jobs.append(job)
		file.close()


func populate_dropdown():
	var dropdown = $JobDropdown
	for job in jobs:
		dropdown.add_item(job["name"])
	dropdown.connect("item_selected", Callable(self, "_on_job_selected")) 
	_on_job_selected(0)  # default job

func _on_job_selected(index):
	var selected_job = jobs[index]
	$JobNameLabel.text = selected_job["name"]
	$JobDescriptionLabel.text = selected_job["description"]
	update_skills(selected_job["skills"])

func update_skills(skill_list):
	var skills_container = $SkillsContainer
	skills_container.clear_children()  # hapus skill sebelumnya
	for skill in skill_list:
		var skill_label = Label.new()
		skill_label.text = skill
		skills_container.add_child(skill_label)
