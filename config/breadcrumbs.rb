crumb :project do |project|
  link "ЯК \"#{project.title}\"", project_path(project)
  parent :projects
end

crumb :region do |region|
  link "Регион #{region.x}-#{region.y}", project_region_path(region.project, region)
  parent :project, region.project
end

crumb :place do |place|
  link "Место #{place.x}-#{place.y}", project_region_place_path(place.region.project, place.region, place)
  parent :region, place.region
end

crumb :projects do |projects|
  link "ЯКи", root_path
end


#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
