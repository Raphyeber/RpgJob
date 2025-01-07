extends VBoxContainer  

func clear_children():
	for child in get_children():
		remove_child(child)  # hapus child dari VBoxContainer
		child.queue_free()   # hapus child secara fisik dari memori
