user1 = User.create(
  email: 'tester1@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)

work_project = user1.projects.create(title: 'Work')
work_project.tasks.create(title: 'General work task',
                          description: 'Just a general work task that needs to be done',
                          due_date: Date.current + 1.week)
work_project.tasks.create(title: 'General work task',
                          description: 'Just a general work task that needs to be done',
                          due_date: Date.current + 1.week,
                          status: 1,
                          priority: 2)
work_project.tasks.create(title: 'General work task',
                          description: 'Just a general work task that needs to be done',
                          due_date: Date.current + 1.week,
                          priority: 1)
work_section = work_project.sections.create(title: 'Work Section')
work_section.tasks.create(title: 'General work section task',
                          description: 'Just a general work section task as part of the section',
                          due_date: Date.current + 1.week,
                          project_id: work_section.project_id)
work_section.tasks.create(title: 'General work section task',
                          description: 'Just a general work section task as part of the section',
                          due_date: Date.current + 1.week,
                          project_id: work_section.project_id)
work_section2 = work_project.sections.create(title: 'Another!!!')
work_section2.tasks.create(title: 'General work section task',
  description: 'Just a general work section task as part of the section',
  due_date: Date.current + 1.week,
  project_id: work_section.project_id)
work_section2.tasks.create(title: 'General work section task',
  description: 'Just a general work section task as part of the section',
  due_date: Date.current + 1.week,
  project_id: work_section.project_id)
work_section2.tasks.create(title: 'General work section task',
  description: 'Just a general work section task as part of the section',
  due_date: Date.current + 1.week,
  project_id: work_section.project_id)
work_section3 = work_project.sections.create(title: 'Another!!!')
work_section3.tasks.create(title: 'General work section task',
  description: 'Just a general work section task as part of the section',
  due_date: Date.current + 1.week,
  project_id: work_section.project_id)
work_section3.tasks.create(title: 'General work section task',
  description: 'Just a general work section task as part of the section',
  due_date: Date.current + 1.week,
  project_id: work_section.project_id)
work_section3.tasks.create(title: 'General work section task',
  description: 'Just a general work section task as part of the section',
  due_date: Date.current + 1.week,
  project_id: work_section.project_id)