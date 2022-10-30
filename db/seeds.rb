work_project = Project.create(title: 'Work')
work_todo = work_project.tasks.create(title: 'General work task')
work_section = work_project.sections.create(title: 'Work Section')
work_section_todo = work_section.tasks.create(title: 'Work section task')
