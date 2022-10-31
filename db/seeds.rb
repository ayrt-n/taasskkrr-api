user1 = User.create(
  email: 'example@example.com',
  password: 'password',
  password_confirmation: 'password'
)

work_project = user1.projects.create(title: 'Work')
work_project.tasks.create(title: 'General work task', user: user1)
work_section = work_project.sections.create(title: 'Work Section')
work_section.tasks.create(title: 'Work section task', user: user1)
